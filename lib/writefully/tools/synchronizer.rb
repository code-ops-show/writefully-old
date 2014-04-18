module Writefully
  module Tools
    class Synchronizer
      include Celluloid

      SYNC_SCRIPT = File.dirname(__FILE__) + "/../../../scripts/sync.sh"

      attr_reader :message

      def initializer message
        @message = message
      end

      def sync
        Writefully.logger.info "Synchronizing #{message[:site_slug]}"
        system(sync_command)
      end

      def sync_command
        ['bash', SYNC_SCRIPT, Writefully.options[:content], message[:site_slug]].join(' ')
      end
    end
  end
end