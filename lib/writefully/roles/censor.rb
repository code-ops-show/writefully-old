module Writefully
  module Roles
    class Censor
      include Celluloid

      trap_exit :handle_exit

      def initialize
        @eraser = Celluloid::Actor[:eraser]
        link @eraser
      end

      def pull(index)
        @eraser.pick_up(index)
        @eraser.async.erase_content
        @eraser.async.erase_assets
      end


      def handle_exit actor, reason
        # when writer fails we need to persist index to the queue so it can be retried
      end
    end
  end
end