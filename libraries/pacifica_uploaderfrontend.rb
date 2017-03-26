# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # installs and configures pacifica ingest frontend wsgi
  class PacificaUploaderFrontend < PacificaBase
    property :name, String, name_property: true
    property :git_opts, Hash, default: {
      repository: 'https://github.com/EMSL-MSC/pacifica-uploader.git',
    }
    property :directory_opts, Hash, default: lazy {
      {
        path: "#{prefix_dir}/uploaderdata",
        recursive: true,
      }
    }
    property :service_opts, Hash, default: lazy {
      {
        environment: {
          VOLUME_PATH: "#{prefix_dir}/uploaderdata",
          BROKER_VHOST: '/uploader',
        },
      }
    }
    property :run_command, String, default: lazy {
      "#{virtualenv_dir}/bin/uwsgi "\
      "--http-socket :#{port} "\
      '--master -p 1 --die-on-term '\
      '--wsgi-file UploadServer/wsgi.py'
    }
    property :port, Integer, default: 8000
    resource_name :pacifica_uploaderfrontend
  end
end
