# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # installs and configures pacifica cart frontend wsgi
  class PacificaCartFrontend < PacificaBase
    resource_name :pacifica_cartfrontend

    property :name, String, name_property: true
    property :command_name, String, default: 'CartServer.py'
    property :pip_install_opts, Hash, default: {
      command: '-m pip install git+https://github.com/pacifica/pacifica-cartd.git@master',
    }
    property :port, Integer, default: 8081
  end
end
