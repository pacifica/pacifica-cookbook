# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # installs and configures pacifica ingest backend celery
  class PacificaIngestBackend < PacificaBase
    resource_name :pacifica_ingestbackend

    property :name, String, name_property: true
    property :git_opts, Hash, default: {
      repository: 'https://github.com/pacifica/pacifica-ingest.git',
    }
    property :service_opts, Hash, default: lazy {
      {
        environment: {
          PYTHONPATH: "#{virtualenv_dir}/lib/python2.7/site-packages",
          VOLUME_PATH: '/srv/',
          MYSQL_ENV_MYSQL_DATABASE: 'ingest',
          MYSQL_ENV_MYSQL_PASSWORD: 'ingest',
          MYSQL_ENV_MYSQL_USER: 'ingest',
          BROKER_VHOST: '/ingest',
        },
      }
    }
    property :run_command, String, default: lazy {
      "#{virtualenv_dir}/bin/python -m celery -A ingest.backend worker -l info"
    }
  end
end
