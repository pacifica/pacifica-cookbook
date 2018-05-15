# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # install and configure pacifica policy service
  class PacificaPolicy < PacificaBase
    resource_name :pacifica_policy

    property :name, String, name_property: true
    property :command_name, String, default: 'PolicyServer.py'
    property :pip_install_opts, Hash, default: {
      command: '-m pip install git+https://github.com/pacifica/pacifica-policy.git@master',
    }
    property :cpconfig_opts, Hash, default: {
      variables: {
        hash: {
          global: {
            'log.access_file' => '\'/var/log/policy-access.log\'',
            'log.error_file' => '\'/var/log/policy-error.log\'',
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
          CHERRYPY_CONFIG: "#{prefix_dir}/#{cpconfig_name}",
        },
      }
    }
    property :port, Integer, default: 8181
  end
end
