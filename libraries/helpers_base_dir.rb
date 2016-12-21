# Pacifica Cookbook Modules
module PacificaCookbook
  # Pacifica Cookbook Helpers
  module PacificaHelpers
    # Directories which should get defined via properties
    module BaseDirectories
      # Define the prefix directory
      def prefix_dir
        "#{prefix}/#{name}"
      end

      # Define the virtualenv directory
      def virtualenv_dir
        "#{prefix_dir}/virtualenv"
      end

      # Define the source directory
      def source_dir
        "#{prefix_dir}/source"
      end
    end
  end
end
