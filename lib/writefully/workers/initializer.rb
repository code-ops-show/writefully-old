module Writefully
  module Workers
    class Initializer
      include Celluloid

      def perform(message)
        inialize_site(message)
      end

      def initialize_site(site_id)
        
      end
    end
  end
end