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
    end
  end
end
