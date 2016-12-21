# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # installs and configures pacifica cart frontend wsgi
  class PacificaCartFrontend < PacificaBase
    resource_name :pacifica_cartfrontend

    property :name, String, name_property: true
    property :git_opts, Hash, default: {
      repository: 'https://github.com/EMSL-MSC/pacifica-cartd.git',
    }
    property :directory_opts, Hash, default: lazy {
      {
        path: "#{prefix_dir}/cartdata",
        recursive: true,
      }
    }
    property :service_opts, Hash, default: lazy {
      {
        environment: {
          VOLUME_PATH: "#{prefix_dir}/cartdata/",
          LRU_BUFFER_TIME: 0,
          MYSQL_ENV_MYSQL_PASSWORD: 'cart',
          MYSQL_ENV_MYSQL_USER: 'cart',
          AMQP_VHOST: '/cart',
        },
      }
    }
    property :wsgi_file, String, default: 'cartserver.py'
    property :port, Integer, default: 8081
  end
end
