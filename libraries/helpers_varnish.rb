# Pacifica Cookbook Modules
module PacificaCookbook
  # Pacifica Cookbook Helpers
  module PacificaHelpers
    # Helpers to call within the varnish
    module Varnish
      # Determine the VLC Hosts
      def vlc_hosts
        ret = {}
        backend_hosts.each do |host|
          unique = Digest.hexencode Digest::MD5.new.digest host
          ret["host#{unique[0..5]}"] = host
        end
        ret
      end
    end
  end
end
