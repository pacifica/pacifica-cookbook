# pacifica cookbook module
module PacificaCookbook
  require_relative 'helpers_base_dir'
  require_relative 'helpers_base'
  # Pacifica base class with common properties and actions
  class PacificaBasePhp < ChefCompat::Resource
    include PacificaHelpers::BaseDirectories
    property :name, String, name_property: true
    property :prefix, String, default: '/opt'
    property :directory_opts, Hash, default: {}
    property :site_fqdn, String, default: 'http://127.0.0.1'
    property :git_opts, Hash, default: {}
    property :git_client_opts, Hash, default: {}
    property :php_fpm_opts, Hash, default: {}
    property :ci_prod_config_opts, Hash, default: {}
    property :ci_prod_config_vars, Hash, default: {
      base_url: 'http://127.0.0.1',
      timezone: 'UTC',
    }
    property :ci_prod_database_opts, Hash, default: {}
    property :ci_prod_database_vars, Hash, default: {
      db_host: '',
      db_user: '',
      db_pass: '',
      db_name: 'database.db',
      db_driver: 'sqlite',
      cache_on: 'TRUE',
      cache_dir: '/tmp',
    }

    default_action :create

    action :create do
      extend PacificaCookbook::PacificaHelpers::Base
      require 'ipaddress'

      include_recipe 'chef-sugar'
      include_recipe 'selinux_policy::install' if rhel?

      # Install the git_client
      git_client new_resource.name.to_s do
        git_client_opts.each do |attr, value|
          send(attr, value)
        end
      end

      directory prefix_dir do
        directory_opts.each do |attr, value|
          send(attr, value)
        end
      end

      # Clone the provided repository and include submodules
      git source_dir do
        enable_submodules true
        git_opts.each do |attr, value|
          send(attr, value)
        end
      end

      directory "#{source_dir}/application/logs"
      include_recipe 'apache2'
      template "#{new_resource.name}_create_prod_database" do
        source 'ci-prod-database.php.erb'
        path "#{source_dir}/application/config/production/database.php"
        cookbook 'pacifica'
        ci_prod_database_opts.each do |attr, value|
          send(attr, value)
        end
        variables(ci_prod_database_vars)
      end
      template "#{new_resource.name}_create_prod_config" do
        source 'ci-prod-config.php.erb'
        path "#{source_dir}/application/config/production/config.php"
        cookbook 'pacifica'
        ci_prod_config_opts.each do |attr, value|
          send(attr, value)
        end
        variables(ci_prod_config_vars)
      end
      # ALL the files under #{source_dir} need to be owned by #{apache_user}
      execute "chown_#{new_resource.name}_files" do
        command "chown -R #{node['apache']['user']}:#{node['apache']['group']} #{source_dir}"
      end
      execute "set_#{new_resource.name}_selinux_context" do
        command "chcon -R system_u:object_r:httpd_sys_content_t:s0 #{source_dir}"
        only_if { rhel? }
      end

      # Install and prep PHP and modules
      include_recipe 'php'
      include_recipe 'php::module_pgsql'
      include_recipe 'php::module_sqlite3'
      include_recipe 'php::module_gd'

      default_attrs = {
        max_children: node['cpu']['total'] * 4,
        start_servers: node['cpu']['total'],
        min_spare_servers: node['cpu']['total'],
        max_spare_servers: node['cpu']['total'],
      }
      case node['platform_family']
      when 'rhel', 'fedora', 'amazon'
        php_log_dir = '/var/log/php-fpm'
      when 'debian'
        php_log_dir = '/var/log'
      end
      default_additional_attrs = {
        'access.log' => "#{php_log_dir}/#{new_resource.name}-access.log",
        'access.format' => '"%R - %u %t \"%m %{REQUEST_URI}e\" %s"',
        'catch_workers_output' => 'yes',
      }
      ipaddress, listen_port = if php_fpm_opts.key?(:listen)
                                 php_fpm_opts[:listen].split(':')
                               else
                                 %w(127.0.0.1 9000)
                               end
      new_hash = if php_fpm_opts.key?(:additional_config)
                   default_additional_attrs.merge(php_fpm_opts[:additional_config])
                 else
                   default_additional_attrs
                 end
      php_fpm_opts[:additional_config] = new_hash
      # Set SELinux Policy Port
      selinux_policy_port "#{new_resource.name}_#{listen_port}" do
        name listen_port
        protocol 'tcp'
        secontext 'http_port_t'
        only_if { rhel? && IPAddress.valid?(ipaddress) }
      end

      # Set SELinux Policy Boolean
      selinux_policy_boolean "#{new_resource.name}_httpd" do
        name 'httpd_can_network_connect'
        value true
        only_if { rhel? }
      end

      php_fpm_pool "#{node['php']['fpm_service']}_#{new_resource.name}" do
        pool_name new_resource.name
        listen "/var/run/php5-fpm-#{new_resource.name}.sock"
        chdir source_dir
        notifies :restart, "service[#{node['php']['fpm_service']}_#{new_resource.name}]"
        default_attrs.merge(php_fpm_opts).each do |attr, value|
          send(attr, value)
        end
      end

      service "#{node['php']['fpm_service']}_#{new_resource.name}" do
        service_name node['php']['fpm_service']
        action [:enable, :start]
      end
    end
  end
end
