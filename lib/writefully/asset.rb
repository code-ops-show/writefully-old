module Writefully
  class Asset
    attr_reader :path, :endpoint

    def initialize(index)
      base_path = [Writefully.options[:content], index[:site], index[:resource], index[:slug]]
      @path = File.join(base_path, 'assets')
      @endpoint = File.join(index[:site], index[:resource], index[:slug], 'assets')
    end

    def names
      Dir.chdir(path) { Dir.glob('*') }
    end

    def regex
      ::Regexp.new('assets\/')
    end

    def url storage_endpoint
      Writefully.options[:assets_host] || File.join(storage_endpoint, endpoint, '/')
    end

    def convert_for content
      if content.is_a?(String)
        content.gsub(regex, url(Writefully::Storage.endpoint))
      elsif content.is_a?(Hash)
        content.inject({}) do |h, (k, v)| 
          h[k] = v.gsub(regex, url(Writefully::Storage.endpoint)); h 
        end 
      end
    end
  end
end