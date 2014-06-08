module Writefully
  module Workers
    class BaseWorker
      include Celluloid

      trap_exit :actor_died

      attr_accessor :message

      def perform(message)
        @message = message
        self.__send__ message[:task]
      end

      def close_db_connection!
        ::ActiveRecord::Base.clear_active_connections! if defined?(::ActiveRecord)
      end

      def actor_died(actor, reason)
        Writefully.logger.error "#{reason.class} #{reason.message} #{reason.backtrace}" if reason
        on_death(actor, reason) if self.respond_to?(:on_death)
      end
    end
  end
end