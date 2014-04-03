require 'celluloid'

module Writefully
  class Worker
    include Celluloid

    def write(indices)
      indicies.each do |index|
        writer = Writer.new(index)
        writer.async.write_content
        writer.async.write_assets
      end
    end
  end
end