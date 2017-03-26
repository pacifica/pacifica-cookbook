# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # installs and configures pacifica cart frontend wsgi
  class PacificaCartFrontend < PacificaBase
    resource_name :pacifica_cartfrontend

    property :name, String, name_property: true
    property :git_opts, Hash, default: {
      repository: 'https://github.com/pacifica/pacifica-cartd.git',
    }
    property :service_opts, Hash, default: lazy {
      {
        environment: {
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
      "#{virtualenv_dir}/bin/uwsgi "\
      "--http-socket :#{port} "\
      "--master -p #{node['cpu']['total']} "\
      '--wsgi-disable-file-wrapper '\
      '--die-on-term '\
      "--wsgi-file #{source_dir}/#{wsgi_file}"
    }
    property :wsgi_file, String, default: 'CartServer.py'
    property :port, Integer, default: 8081
  end
end
