# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # installs and configures pacifica ingest backend celery
  class PacificaUploaderBackend < PacificaBase
    property :name, String, name_property: true
    property :git_opts, Hash, default: {
      repository: 'https://github.com/EMSL-MSC/pacifica-uploader.git',
    }
    property :service_opts, Hash, default: lazy {
      {
        environment: {
          PYTHONPATH: "#{virtualenv_dir}/lib/python2.7/site-packages",
          VOLUME_PATH: "#{prefix_dir}/uploaderdata",
          BROKER_VHOST: '/uploader',
        },
      }
    }
    property :run_command, String, default: lazy {
      "#{virtualenv_dir}/bin/python -m celery -A UploadServer worker -l info"
    }
    resource_name :pacifica_uploaderbackend
  end
end
