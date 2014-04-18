module Writefully
  module Workers
    class Handyman
      include Celluloid
      include Helpers::Handyman

      trap_exit :actor_died

      attr_reader :site, :message

      TASKS = { 
        build:       -> (message) { build(message) },
        synchronize: -> (message) { synchronize(message) }
      }

      def perform(message)
        TASKS[message[:task]].call(message)
      end

      def build(message)
        @message   = message
        @site      = Site.where(id: message[:site_id]).first

        @hammer    = Tools::Hammer.new_link(message.merge({domain: site.domain }))

        repo, hook = build_repository
        complete_site_setup(repo, hook)

        @initializer = Tools::Initializer.new_link(message.merge({ ssh_url: repo.ssh_url }))
        initialize_sample_content
      ensure
        @hammer.terminate
        @initializer.terminate
        clear_db_connection!
      end

      def synchronize(message)
        @synchronizer = Tools::Synchronizer.new_link(message)
        synced = @synchronizer.future.sync
        Writefully.logger.info "Synchronized #{message[:site_slug]}" if synced.value
      ensure
        @synchronizer.terminate
      end

      def actor_died actor, reason
        Writefully.logger.info "#{reason.message}"
        Writefully.redis.with { |c| s.sadd "site:#{site.id}:errors", reason.message }
        site.update_attributes(processing: false, healty: false)
      end
    end
  end
end