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
          end
        end
      end

      def base_directory_resources
        directory prefix_dir do
          directory_opts.each do |attr, value|
            send(attr, value)
          end
        end
      end

      def base_git_client
        git_client new_resource.name do
          git_client_opts.each do |attr, value|
            send(attr, value)
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
          notifies :restart, "service[#{new_resource.service_name}]"
          config_opts.each do |attr, value|
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
export LD_LIBRARY_PATH=/opt/chef/embedded/lib
export LD_RUN_PATH=/opt/chef/embedded/lib
exec -a #{new_resource.service_name} #{run_command}
HDOC
          notifies :restart, "service[#{new_resource.service_name}]"
          script_opts.each do |attr, value|
            send(attr, value)
          end
        end
      end

      def base_poise_service
        poise_service new_resource.service_name do
          command "#{prefix_dir}/#{new_resource.script_name}"
          service_opts.each do |attr, value|
            send(attr, value)
          end
        end
      end

      def base_service
        service new_resource.service_name do
          action [:enable, :start]
        end
      end

      def base_python_runtime
        python_runtime new_resource.name do
          python_opts.each do |attr, value|
            send(attr, value)
          end
        end
      end

      def base_python_virtualenv
        python_virtualenv prefix_dir do
          virtualenv_opts.each do |attr, value|
            send(attr, value)
          end
        end
      end

      def base_python_execute_requirements
        python_execute "#{new_resource.name}_requirements" do
          virtualenv prefix_dir
          pip_install_opts.each do |attr, value|
            send(attr, value)
          end
        end
      end
    end
  end
end
