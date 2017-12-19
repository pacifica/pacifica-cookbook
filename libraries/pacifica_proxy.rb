# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # install and configure pacifica policy service
  class PacificaProxy < PacificaBase
    resource_name :pacifica_proxy

    property :name, String, name_property: true
    property :command_name, String, default: 'ProxyServer.py'
    property :pip_install_opts, Hash, default: {
      command: '-m pip install git+https://github.com/pacifica/pacifica-proxy.git@master',
    }
    property :config_opts, Hash, default: {
      variables: {
        hash: {
          global: {
            'log.access_file' => '\'/var/log/proxy-access.log\'',
            'log.error_file' => '\'/var/log/proxy-error.log\'',
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
          CHERRYPY_CONFIG: "#{prefix_dir}/#{config_name}",
        },
      }
    }
    property :port, Integer, default: 8180
  end
end
