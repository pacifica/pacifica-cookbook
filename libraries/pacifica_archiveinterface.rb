# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # Manages the Pacifica archive interface service
  class PacificaArchiveInterface < PacificaBase
    resource_name :pacifica_archiveinterface

    property :name, String, name_property: true
    property :git_opts, Hash, default: {
      repository: 'https://github.com/pacifica/pacifica-archiveinterface.git',
    }
    property :script_opts, Hash, default: lazy {
      {
        content: <<EOF
#!/bin/bash
. #{virtualenv_dir}/bin/activate
export LD_LIBRARY_PATH=/opt/chef/embedded/lib
export LD_RUN_PATH=/opt/chef/embedded/lib
cd /
exec -a #{name} #{run_command}
EOF
      }
    }
    property :wsgi_file, String, default: 'archiveinterface/wsgi.py'
    property :port, Integer, default: 8080
  end
end
