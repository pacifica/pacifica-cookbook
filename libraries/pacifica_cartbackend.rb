# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # installs and configures pacifica cart backend celery
  class PacificaCartBackend < PacificaBase
    resource_name :pacifica_cartbackend

    property :name, String, name_property: true
    property :pip_install_opts, Hash, default: {
      command: '-m pip install git+https://github.com/pacifica/pacifica-cartd.git@master',
    }
    property :run_command, String, default: 'python -m celery -A cart worker -l info'
    property :service_opts, Hash, default: lazy {
      {
        directory: prefix_dir,
        environment: {
          AMQP_VHOST: '/cart',
        },
      }
    }
  end
end
