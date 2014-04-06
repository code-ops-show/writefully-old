module Writefully
  module Tasks
    module Writer
      extend ActiveSupport::Concern
      
      def write(index)
        writer = ::Writer.new(index)
        writer.write_content
        writer.write_assets
      end

      def erase(index)
        
      end
    end
  end
end