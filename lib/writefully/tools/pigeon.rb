module Writefully
  module Tools
    class Pigeon
      include Celluloid

      def upload endpoint, path, name
        file = File.open(File.join(path, name))
        Writefully::Storage.store_file(File.join(endpoint, name), file)
      rescue StandardError => e
        nil
      end

      def remove endpoint, path, name
        
      end
    end
  end
end