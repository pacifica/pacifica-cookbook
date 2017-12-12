# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # installs and configures pacifica ingest frontend wsgi
  class PacificaIngestFrontend < PacificaBase
    resource_name :pacifica_ingestfrontend

    property :name, String, name_property: true
    property :command_name, String, default: 'IngestServer.py'
    property :pip_install_opts, Hash, default: {
      command: '-m pip install git+https://github.com/pacifica/pacifica-ingest.git@master',
    }
    property :config_opts, Hash, default: {
      variables: {
        hash: {
          global: {
            'log.access_file': '\'/var/log/ingestserver-access.log\'',
	    'log.error_file': '\'/var/log/ingestserver-error.log\'',
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
          		    VOLUME_PATH: '/srv/',
			    BROKER_VHOST: '/ingest',
			    CHERRYPY_CONFIG: '/opt/default/PacificaIngestFrontend.ini'
		    },
	    }
    }
    property :port, Integer, default: 8066
  end
end
