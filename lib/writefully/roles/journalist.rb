module Writefully
  module Roles
    class Journalist
      include Celluloid

      trap_exit :handle_exit

      def initialize
        # on starting we should look for pending jobs from the queue
      end

      def write(index)
        pencil = Tools::Pencil.new_link(index)
        pencil.async.write_content
        pencil.async.write_assets
        pencil.terminate
      end

      def remove(index)
        eraser = Tools::Eraser.new_link(index)
        eraser.async.erase_content
        eraser.async.erase_assets
        eraser.terminate
      end


      def handle_exit
        # when writer fails we need to persist index to the queue so it can be retried
      end
    end
  end
end