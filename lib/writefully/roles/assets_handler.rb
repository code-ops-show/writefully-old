module Writefully
  module Roles
    class AssetsHandler
      include Celluloid

      def upload endpoint, path, name
        file = File.open(File.join(path, name))
        s3_file = ::STORAGE.store_file(File.join(endpoint, name), file)
      end

      def remove endpoint, path, name
        
      end
    end
  end
end