module Writefully
  class Content
    attr_reader :index, :path
    attr_accessor :body

    def initialize(index)
      @index = index
      @path = File.join(Writefully.options[:content], index[:resource], index[:slug])
    end

    def body
      @body ||= File.open(File.join(path, 'README.md')).read
    end

    def meta
      YAML.load(File.read(File.join(path, "meta.yml"))).merge({ "position" => position })
    end

    def details
      Hashie::Mash.new(meta["details"])
    end

    def slug
      meta["slug"] || index[:slug].split(/\d-/).last
    end

    def position
      index[:slug].match(/\d/).to_s.to_i
    end
  end
end 