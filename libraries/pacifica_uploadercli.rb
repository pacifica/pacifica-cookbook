# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # Manages the Pacifica archive interface service
  class PacificaUploaderCLI < PacificaBase
    resource_name :pacifica_uploadercli

    property :name, String, name_property: true
    property :pip_install_opts, Hash, default: {
      command: '-m pip install git+https://github.com/pacifica/pacifica-cli-uploader.git@master',
    }
    property :service_disabled, [TrueClass, FalseClass], default: true
  end
end
