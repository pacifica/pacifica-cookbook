# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # install and configure pacifica uniqueid service
  class PacificaUniqueid < PacificaBase
    resource_name :pacifica_uniqueid

    property :name, String, name_property: true
    property :git_opts, Hash, default: {
      repository: 'https://github.com/pacifica/pacifica-uniqueid.git',
    }
    property :service_opts, Hash, default: lazy {
      {
        environment: {
          MYSQL_PORT_3306_TCP_ADDR: '127.0.0.1',
          MYSQL_ENV_MYSQL_DATABASE: 'uniqueid',
          MYSQL_ENV_MYSQL_USER: 'uniqueid',
          MYSQL_ENV_MYSQL_PASSWORD: 'uniqueid',
        },
      }
    }
    property :wsgi_file, String, default: 'UniqueIDServer.py'
    property :port, Integer, default: 8051
  end
end
