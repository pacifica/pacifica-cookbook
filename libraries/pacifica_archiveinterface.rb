# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # Manages the Pacifica archive interface service
  class PacificaArchiveInterface < PacificaBase
    resource_name :pacifica_archiveinterface

    property :name, String, name_property: true
    property :command_name, String, default: 'ArchiveInterfaceServer.py'
    property :pip_install_opts, Hash, default: {
      command: '-m pip install git+https://github.com/pacifica/pacifica-archiveinterface.git@master',
    }
    property :cpconfig_opts, Hash, default: {
      variables: {
        hash: {
          'global' => {
            'log.screen' => 'True',
            'log.access_file' => '\'access.log\'',
            'log.error_file' => '\'error.log\'',
            'server.socket_host' => '\'0.0.0.0\'',
            'server.socket_port' => 8080,
            'server.max_request_body_size' => 0,
            'server.socket_timeout' => 60,
            'response.timeout' => 3600,
          },
          '/' => {
            'request.dispatch' => 'cherrypy.dispatch.MethodDispatcher()',
            'tools.response_headers.on' => 'True',
            'tools.response_headers.headers' => '[(\'Content-Type\', \'application/json\')]',
          },
        },
      },
    }
    property :config_opts, Hash, default: {
      variables: {
        hash: {
          posix: {
            use_id2filename: false,
          },
          hpss: {
            user: 'hpss.unix',
            auth: '/var/hpss/etc/hpss.unix.keytab',
          },
          hms_sideband: {
            sam_qfs_prefix: '/pacificadata',
            schema: 'samqfs1db',
            host: 'host',
            user: 'user',
            password: 'pass',
            port: 3306,
          },
        },
      },
    }
    property :service_opts, Hash, default: lazy {
      {
        directory: prefix_dir,
        environment: {
          ARCHIVEI_CONFIG: "#{prefix_dir}/#{config_name}",
          CP_CONFIG: "#{prefix_dir}/#{cpconfig_name}",
        },
      }
    }
    property :port, Integer, default: 8080
  end
end
