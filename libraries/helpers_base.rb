# Pacifica Cookbook Modules
module PacificaCookbook
  # Pacifica Cookbook Helpers
  module PacificaHelpers
    # Helpers to call within the base action
    module Base
      # Create prefixed directories
      def base_packages
        package "#{new_resource.name}_packages" do
          if rhel?
            package_name 'sqlite-devel'
          elsif debian?
            package_name %w(sqlite3 sqlite3-doc libsqlite3-dev)
          elsif freebsd?
            package_name 'sqlite3'
          end
        end
      end

      def base_directory_resources
        directory prefix_dir do
          new_resource.directory_opts.each do |attr, value|
            send(attr, value)
          end
        end
      end

      def base_git_client
        if freebsd?
          package 'git'
        else
          git_client new_resource.name do
            new_resource.git_client_opts.each do |attr, value|
              send(attr, value)
            end
          end
        end
      end

      def base_config
        template "#{prefix_dir}/#{new_resource.config_name}" do
          source 'config.ini.erb'
          cookbook 'pacifica'
          owner 'root'
          group 'root'
          mode '0600'
          notifies :restart, "service[#{new_resource.service_name}]" unless new_resource.service_disabled
          new_resource.config_opts.each do |attr, value|
            send(attr, value)
          end
        end
      end

      def base_file
        file "#{prefix_dir}/#{new_resource.script_name}" do
          owner 'root'
          group 'root'
          mode '0700'
          content <<-HDOC
#!/bin/bash
. #{prefix_dir}/bin/activate
export LD_LIBRARY_PATH=/opt/chef/embedded/lib:/opt/rh/python27/root/usr/lib64
export LD_RUN_PATH=/opt/chef/embedded/lib:/opt/rh/python27/root/usr/lib64
exec -a #{new_resource.service_name} #{new_resource.run_command}
HDOC
          notifies :restart, "service[#{new_resource.service_name}]"
          new_resource.script_opts.each do |attr, value|
            send(attr, value)
          end
        end unless new_resource.service_disabled
      end

      def base_poise_service
        poise_service new_resource.service_name do
          command "#{prefix_dir}/#{new_resource.script_name}"
          provider :sysvinit if redhat? && (node['platform_version'].to_i == 6)
          new_resource.service_opts.each do |attr, value|
            send(attr, value)
          end
        end unless new_resource.service_disabled
      end

      def base_service
        service new_resource.service_name do
          action new_resource.service_actions
        end unless new_resource.service_disabled
      end

      def base_python_runtime
        if freebsd?
          short_version = python_opts[:version].delete('.')
          package 'python packages' do
            package_name %W(py#{short_version}-pip py#{short_version}-virtualenv)
          end
        else
          python_runtime new_resource.name do
            new_resource.python_opts.each do |attr, value|
              send(attr, value)
            end
          end
        end
      end

      def base_python_virtualenv
        python_virtualenv prefix_dir do
          new_resource.virtualenv_opts.each do |attr, value|
            send(attr, value)
          end
        end
      end

      def base_python_execute_requirements
        python_execute "#{new_resource.name}_requirements" do
          virtualenv prefix_dir
          notifies :restart, "service[#{new_resource.service_name}]" unless new_resource.service_disabled
          new_resource.pip_install_opts.each do |attr, value|
            send(attr, value)
          end
        end
      end
    end
  end
end
