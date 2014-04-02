require 'celluloid'

module Writefully
  class Worker
    include Celluloid

    def write(index)
      writer = Writer.new(index)
      writer.async.write_assets
      writer.async.write_content
    end
  end
end