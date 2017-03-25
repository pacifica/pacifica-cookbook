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

      def base_git
        git source_dir do
          notifies :restart, "service[#{new_resource.name}]"
          git_opts.each do |attr, value|
            send(attr, value)
          end
        end
      end

      def base_file
        file "#{prefix_dir}/#{new_resource.name}" do
          owner 'root'
          group 'root'
          mode '0700'
          content <<-HDOC
#!/bin/bash
. #{virtualenv_dir}/bin/activate
export PYTHONPATH=#{virtualenv_dir}/lib64/python2.7/site-packages
export LD_LIBRARY_PATH=/opt/chef/embedded/lib
export LD_RUN_PATH=/opt/chef/embedded/lib
cd #{source_dir}
exec -a #{new_resource.name} #{run_command}
HDOC
          notifies :restart, "service[#{new_resource.name}]"
          script_opts.each do |attr, value|
            send(attr, value)
          end
        end
      end

      def base_systemd_service
        systemd_service new_resource.name do
          description "start #{new_resource.name} in python"
          after %w(network.target)
          install do
            wanted_by 'multi-user.target'
          end
          service do
            working_directory source_dir
            exec_start "#{prefix_dir}/#{new_resource.name}"
            service_opts.each do |attr, value|
              send(attr, value)
            end
          end
          notifies :restart, "service[#{new_resource.name}]"
        end
      end

      def base_service
        service new_resource.name do
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
        python_virtualenv virtualenv_dir do
          virtualenv_opts.each do |attr, value|
            send(attr, value)
          end
        end
      end

      def base_python_execute_requirements
        python_execute "#{new_resource.name}_requirements" do
          virtualenv virtualenv_dir
          command "-m pip install -r #{source_dir}/requirements.txt"
          pip_install_opts.each do |attr, value|
            send(attr, value)
          end
        end
      end

      def base_python_execute_uwsgi
        python_execute "#{new_resource.name}_uwsgi" do
          virtualenv virtualenv_dir
          command '-m pip install uwsgi'
          not_if { ::File.exist?("#{virtualenv_dir}/bin/uwsgi") }
        end
      end

      def base_python_execute_dbcreate
        python_execute "#{new_resource.name}_dbcreate" do
          virtualenv virtualenv_dir
          cwd source_dir
          command "DatabaseCreate.py && touch #{prefix_dir}/.dbcreate"
          only_if { ::File.exist?("#{source_dir}/DatabaseCreate.py") }
          not_if { ::File.exist?("#{prefix_dir}/.dbcreate") }
          build_opts.each do |attr, value|
            send(attr, value)
          end
        end
      end

      def base_python_execute_build
        python_execute "#{new_resource.name}_build" do
          virtualenv virtualenv_dir
          cwd source_dir
          command "setup.py install --prefix #{virtualenv_dir}"
          only_if { ::File.exist?("#{source_dir}/setup.py") }
          build_opts.each do |attr, value|
            send(attr, value)
          end
        end
      end
    end
  end
end
