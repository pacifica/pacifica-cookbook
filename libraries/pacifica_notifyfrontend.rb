# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # install and configure pacifica policy service
  class PacificaNotificationsFrontend < PacificaBase
    resource_name :pacifica_notifyfrontend

    property :name, String, name_property: true
    property :run_command, String, default: 'pacifica-notifications'
    property :pip_install_opts, Hash, default: {
      command: '-m pip install git+https://github.com/pacifica/pacifica-notifications.git@master',
    }
    property :cpconfig_opts, Hash, default: {
      variables: {
        hash: {
          global: {
            'log.access_file' => '\'/var/log/notify-access.log\'',
            'log.error_file' => '\'/var/log/notify-error.log\'',
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
          NOTIFICATIONS_CPCONFIG: "#{prefix_dir}/#{cpconfig_name}",
        },
      }
    }
    property :port, Integer, default: 8070
  end
end
