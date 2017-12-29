# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # Manages the Pacifica archive interface service
  class PacificaUploader < PacificaBase
    resource_name :pacifica_uploader

    property :name, String, name_property: true
    property :pip_install_opts, Hash, default: {
      command: '-m pip install git+https://github.com/pacifica/pacifica-python-uploader.git@master',
    }
    property :service_disabled, [TrueClass, FalseClass], default: true
  end
end
