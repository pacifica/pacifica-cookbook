# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # install and configure pacifica metadata service
  class PacificaMetadata < PacificaBase
    resource_name :pacifica_metadata

    property :name, String, name_property: true
    property :command_name, String, default: 'MetadataServer.py'
    property :pip_install_opts, Hash, default: {
      command: '-m pip install git+https://github.com/pacifica/pacifica-metadata.git',
    }
    property :config_opts, Hash, default: {
        variables: {
            hash: {
                global: {
                    'log.access_file': '\'/var/log/metadata-access.log\'',
		    'log.error_file': '\'/var/log/metadata-error.log\'',
		    'server.socket_host': '\'127.0.0.1\''
		},
		'/': {
                    'request.dispatch': 'cherrypy.dispatch.MethodDispatcher()',
		    'tools.response_headers.on': 'True',
		    'tools.response_headers.headers': "[('Content-Type', 'application/json')]"
		}
	    },
	}
    }
    property :service_opts, Hash, default: lazy {
        {
            directory: prefix_dir,
	    environment: {
		CHERRYPY_CONFIG: '/opt/default/PacificaMetadata.ini'
	    },
	}
    }
    property :port, Integer, default: 8121
  end
end
