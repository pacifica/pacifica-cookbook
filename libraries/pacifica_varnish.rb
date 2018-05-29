require 'digest'
# pacifica cookbook module
module PacificaCookbook
  require_relative 'helpers_varnish'
  # Manages the Pacifica varnish service
  class PacificaVarnish < Chef::Resource
    include PacificaHelpers::Varnish
    resource_name :pacifica_varnish

    property :name, String, name_property: true
    property :backend_hosts, Array, default: []
    property :probe_url, String, default: '/robots.txt'
    property :listen_port, Integer, default: 6081
    property :repo_opts, Hash, default: {}
    property :config_opts, Hash, default: {}
    property :template_opts, Hash, default: {}
    # Varnish Repo properties (from varnish cookbook)
    property :major_version, kind_of: Float, equal_to: [2.1, 3.0, 4.0, 4.1], default: lazy { node['varnish']['major_version'] }
    property :fetch_gpg_key, kind_of: [TrueClass, FalseClass], default: true

    default_action :create

    action :create do
      include_recipe 'chef-sugar'
      include_recipe 'selinux_policy::install' if rhel?
      selinux_policy_port listen_port do
        protocol 'tcp'
        secontext 'varnishd_port_t'
        only_if { rhel? }
      end
      selinux_policy_boolean 'varnishd_connect_any' do
        value true
        only_if { rhel? }
      end
      # The varnish cookbook/src upstream does not yet support ubuntu 16.04, temporary fix here
      case node['platform_family']
      when 'debian'
        apt_repository "varnish-cache_#{new_resource.major_version}" do
          uri "http://repo.varnish-cache.org/#{node['platform']}"
          if node['platform_version'].to_f == '16'
            distribution 'trusty'
          else
            distribution node['lsb']['codename']
          end
          components ["varnish-#{new_resource.major_version}"]
          key "https://repo.varnish-cache.org/#{node['platform']}/GPG-key.txt" if new_resource.fetch_gpg_key
          deb_src true
          action :add
        end
      when 'rhel'
        varnish_repo new_resource.name do
          repo_opts.each do |key, attr|
            send(key, attr)
          end
        end
      end
      package 'varnish'
      varnish_config 'default' do
        listen_address '0.0.0.0'
        admin_listen_address '127.0.0.1'
        listen_port new_resource.listen_port
        notifies :restart, 'service[varnish]'
        config_opts.each do |key, attr|
          send(key, attr)
        end
      end
      vcl_template 'default.vcl' do
        cookbook 'pacifica'
        source 'backends.vcl.erb'
        variables(
          endpoint_name: new_resource.name,
          backend_hosts: vlc_hosts,
          probe_url: new_resource.probe_url
        )
        notifies :restart, 'service[varnish]'
        template_opts.each do |key, attr|
          send(key, attr)
        end
      end
      service 'varnish' do
        action [:enable, :start]
      end
      file '/var/log/varnish/varnishlog.log' do
        action [:create_if_missing]
      end
      selinux_policy_module 'allow_varnishlog_vsm' do
        content <<-EOS
	module allow_varnishlog_vsm 1.0;

        require {
          type varnishlog_t;
          type varnishd_var_lib_t;
          class lnk_file { read };
        }
	#============= varnishlog_t ==============
	allow varnishlog_t varnishd_var_lib_t:lnk_file read;
        EOS
        only_if { rhel? }
        action :deploy
      end
      execute 'restorecon /var/log/varnish/*' do
        only_if { rhel? }
      end
      varnish_log 'default'
    end
  end
end
