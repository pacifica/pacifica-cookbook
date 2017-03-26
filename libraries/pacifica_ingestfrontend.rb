# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # installs and configures pacifica ingest frontend wsgi
  class PacificaIngestFrontend < PacificaBase
    resource_name :pacifica_ingestfrontend

    property :name, String, name_property: true
    property :git_opts, Hash, default: {
      repository: 'https://github.com/pacifica/pacifica-ingest.git',
    }
    property :service_opts, Hash, default: lazy {
      {
        environment: {
          VOLUME_PATH: "/srv/",
          MYSQL_ENV_MYSQL_DATABASE: 'ingest',
          MYSQL_ENV_MYSQL_PASSWORD: 'ingest',
          MYSQL_ENV_MYSQL_USER: 'ingest',
          BROKER_VHOST: '/ingest',
        },
      }
    }
    property :wsgi_file, String, default: 'IngestServer.py'
    property :port, Integer, default: 8066
  end
end
