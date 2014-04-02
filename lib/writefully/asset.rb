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
  end
end