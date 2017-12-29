# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # installs and configures pacifica cart frontend wsgi
  class PacificaCartFrontend < PacificaBase
    resource_name :pacifica_cartfrontend

    property :name, String, name_property: true
    property :command_name, String, default: 'CartServer.py'
    property :pip_install_opts, Hash, default: {
      command: '-m pip install git+https://github.com/pacifica/pacifica-cartd.git@master',
    }
    property :config_opts, Hash, default: {
      variables: {
        hash: {
          global: {
            'log.access_file' => '\'/var/log/cartserver-access.log\'',
            'log.error_file' => '\'/var/log/cartserver-error.log\'',
            'server.socket_host' => '\'127.0.0.1\'',
          },
          '/' => {
            'request.dispatch' => 'cherrypy.dispatch.MethodDispatcher()',
            'tools.response_headers.on' => 'True',
            'tools.response_headers.headers' => "[('Content-Type', 'application/json')]",
          },
        },
      },
    }
    property :service_opts, Hash, default: lazy {
      {
        directory: prefix_dir,
        environment: {
          AMQP_VHOST: '/cart',
          CHERRYPY_CONFIG: "#{prefix_dir}/#{config_name}",
        },
      }
    }
    property :port, Integer, default: 8081
  end
end
