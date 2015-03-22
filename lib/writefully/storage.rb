module Writefully
  module Storage
    class << self 
      def directory
        @directory ||= connection.directories.get(Writefully.options[:storage_folder])
      end

      def store_file(path, body)
        directory.files.create({
          key: path,
          body: body,
          public: true
        })
      end

      def remove_file(key)
        directory.files.get(key).destroy
      end

      def endpoint
        Writefully.options[:assets_host] || provider_endpoints[Writefully.options[:storage_provider].downcase.to_sym]
      end

      def provider_endpoints
        { aws: "https://#{Writefully.options[:storage_folder]}.s3.amazonaws.com"}
      end

      def connection
        @connection ||= Fog::Storage.new({
          provider:              Writefully.options[:storage_provider],
          aws_access_key_id:     Writefully.options[:storage_key],
          aws_secret_access_key: Writefully.options[:storage_secret],
          region:                Writefully.options[:storage_region]
        })
      end
    end
  end
end