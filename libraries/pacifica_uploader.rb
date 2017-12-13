# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # Manages the Pacifica archive interface service
  class PacificaArchiveInterface < PacificaBase
    resource_name :pacifica_archiveinterface

    property :name, String, name_property: true
    property :pip_install_opts, Hash, default: {
      command: '-m pip install git+https://github.com/pacifica/pacifica-python-uploader.git@master',
    }
    property :config_opts, Hash, default: {
      only_if: lazy { false }
    }
    property :script_opts, Hash, default: {
      only_if: lazy { false }
    }
    property :service_opts, Hash, default: {
      only_if: lazy { false }
    }
    property :service_actions, Hash, default: []
  end
end
