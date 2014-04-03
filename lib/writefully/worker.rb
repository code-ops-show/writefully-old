require 'celluloid'

module Writefully
  class Worker
    include Celluloid

    def write(index)
      writer = Writer.new(index)
      writer.write_content
      writer.write_assets
    end
  end
end