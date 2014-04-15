module Writefully
  module Workers
    class Journalist
      include Celluloid

      trap_exit :actor_died

      attr_reader :index

      def perform(message)
        publish_content(message)
      end

      def publish_content(index)
        Writefully.logger.info "Publishing #{index[:resource]} #{index[:slug]}"
        @index = index
        pencil = Tools::Pencil.new_link(index)
        pencil.perform
      end

      def index_with_tries
        index.merge({ tries: (index[:tries] || 1) + 1 })
      end

      def actor_died actor, reason
        Writefully.logger.error "An error occured #{reason.message}"
        Writefully.add_job :journalists, index_with_tries
      end
    end
  end
end