# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # install and configure pacifica policy service
  class PacificaProxy < PacificaBase
    resource_name :pacifica_proxy

    property :name, String, name_property: true
    property :git_opts, Hash, default: {
      repository: 'https://github.com/EMSL-MSC/pacifica-proxy.git',
    }
    property :wsgi_file, String, default: 'ProxyServer.py'
    property :port, Integer, default: 8180
  end
end
