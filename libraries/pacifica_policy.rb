# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # install and configure pacifica policy service
  class PacificaPolicy < PacificaBase
    resource_name :pacifica_policy

    property :name, String, name_property: true
    property :git_opts, Hash, default: {
      repository: 'https://github.com/EMSL-MSC/pacifica-policy.git',
    }
    property :wsgi_file, String, default: 'PolicyServer.py'
    property :port, Integer, default: 8181
  end
end
