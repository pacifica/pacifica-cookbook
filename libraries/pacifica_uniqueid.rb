# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # install and configure pacifica uniqueid service
  class PacificaUniqueid < PacificaBase
    resource_name :pacifica_uniqueid

    property :name, String, name_property: true
    property :command_name, String, default: 'UniqueIDServer.py'
    property :pip_install_opts, Hash, default: {
      command: '-m pip install git+https://github.com/pacifica/pacifica-uniqueid.git@master',
    }
    property :config_opts, Hash, default: {
      variables: {
        hash: {
          global: {
            'log.access_file' => '\'/var/log/uniqueid-access.log\'',
            'log.error_file' => '\'/var/log/uniqueid-error.log\'',
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
          CHERRYPY_CONFIG: config_name,
        },
      }
    }
    property :port, Integer, default: 8051
  end
end
