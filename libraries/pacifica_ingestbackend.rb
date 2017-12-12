# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # installs and configures pacifica ingest backend celery
  class PacificaIngestBackend < PacificaBase
    resource_name :pacifica_ingestbackend

    property :name, String, name_property: true
    property :pip_install_opts, Hash, default: {
      command: '-m pip install git+https://github.com/pacifica/pacifica-ingest.git@master',
    }
    property :run_command, String, default: 'python -m celery -A ingest.backend worker -l info'
    property :service_opts, Hash, default: lazy {
      {
        directory: prefix_dir,
        environment: {
          VOLUME_PATH: '/srv/',
          BROKER_VHOST: '/ingest',
        },
      }
    }
  end
end
