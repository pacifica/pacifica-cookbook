# This is the primary shared library for Pacifica custom resources
module PacificaCookbook
  require_relative 'helpers_base_dir'
  require_relative 'helpers_base'
  # Pacifica base class with common properties and actions
  class PacificaBase < ChefCompat::Resource
    include PacificaHelpers::BaseDirectories
    property :name, String, name_property: true
    property :prefix, String, default: '/opt'
    property :directory_opts, Hash, default: {}
    property :virtualenv_opts, Hash, default: {}
    property :python_opts, Hash, default: { version: '2.7' }
    property :pip_install_opts, Hash, default: {}
    property :build_opts, Hash, default: {}
    property :script_opts, Hash, default: {}
    property :git_opts, Hash, default: {}
    property :git_client_opts, Hash, default: {}
    property :service_opts, Hash, default: {}
    property :wsgi_file, String, default: 'server.py'
    property :port, Integer, default: 8080
    property :run_command, String, default: lazy {
      "#{virtualenv_dir}/bin/uwsgi "\
      "--http-socket :#{port} "\
      "--master -p #{node['cpu']['total']} "\
      "--wsgi-file #{source_dir}/#{wsgi_file}"
    }
    default_action :create
    action :create do
      extend PacificaCookbook::PacificaHelpers::Base
      include_recipe 'chef-sugar'
      base_packages
      base_directory_resources
      base_git_client
      base_git
      base_python_runtime
      base_python_virtualenv
      base_python_execute_requirements
      base_python_execute_uwsgi
      base_python_execute_build
      base_python_execute_dbcreate
      base_file
      base_systemd_service
      base_service
    end
  end
end
