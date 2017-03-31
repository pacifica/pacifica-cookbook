# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # installs and configures pacifica cart backend celery
  class PacificaCartBackend < PacificaBase
    resource_name :pacifica_cartbackend

    property :name, String, name_property: true
    property :git_opts, Hash, default: {
      repository: 'https://github.com/pacifica/pacifica-cartd.git',
    }
    property :service_opts, Hash, default: lazy {
      {
        environment: {
          PYTHONPATH: "#{virtualenv_dir}/lib/python2.7/site-packages",
          VOLUME_PATH: '/srv/',
          LRU_BUFFER_TIME: '0',
          MYSQL_ENV_MYSQL_DATABASE: 'cartd',
          MYSQL_ENV_MYSQL_PASSWORD: 'cart',
          MYSQL_ENV_MYSQL_USER: 'cart',
          AMQP_VHOST: '/cart',
        },
      }
    }
    property :run_command, String, default: lazy {
      "#{virtualenv_dir}/bin/python -m celery -A cart worker -l info"
    }
  end
end
