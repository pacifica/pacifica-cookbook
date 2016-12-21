# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # install and configure pacifica metadata service
  class PacificaMetadata < PacificaBase
    resource_name :pacifica_metadata

    property :name, String, name_property: true
    property :git_opts, Hash, default: {
      repository: 'https://github.com/EMSL-MSC/pacifica-metadata.git',
    }
    property :service_opts, Hash, default: lazy {
      {
        environment: {
          POSTGRES_ENV_POSTGRES_DB: 'metadata',
          POSTGRES_ENV_POSTGRES_USER: 'metadata',
          POSTGRES_ENV_POSTGRES_PASSWORD: 'metadata',
        },
      }
    }
    property :wsgi_file, String, default: 'MetadataServer.py'
    property :port, Integer, default: 8121
  end
end
