module Writefully
  class Asset
    attr_reader :path, :endpoint

    def initialize(index)
      base_path = [Writefully.options[:content], index[:resource], index[:slug]]
      @path = File.join(base_path, 'assets')
      @endpoint = File.join(index[:resource], index[:slug], 'assets')
    end

    def names
      Dir.chdir(path) { Dir.glob('*') }
    end

    def regex
      ::Regexp.new('assets\/')
    end

    def url storage_endpoint
      File.join(storage_endpoint, endpoint, '/')
    end

    def convert_for content
      if content.is_a?(String)
        content.gsub(regex, url(STORAGE.endpoint))
      elsif content.is_a?(Hash)
        content.inject({}) do |h, (k, v)| 
          h[k] = v.gsub(regex, url(STORAGE.endpoint)); h 
        end 
      end
    end
  end
end