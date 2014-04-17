module Writefully
  module Workers
    class Builder
      include Celluloid

      trap_exit :actor_died

      attr_reader :site, :message

      def perform(message)
        build(message)
      end

      def build(message)
        @message   = message
        @site      = Site.where(id: message[:site_id]).first

        @hammer    = Tools::Hammer.new_link(message.merge({domain: site.domain }))

        repo, hook = build_repository
        complete_site_setup(repo, hook)
      ensure
        @hammer.terminate
        clear_db_connection!
        Writefully.add_job :initializer, message.merge({ ssh_url: repo.ssh_url })
      end

      def build_repository
        created_repo = @hammer.future.forge
        added_hook   = @hammer.future.add_hook_for(created_repo.value.name)

        [created_repo.value, added_hook.value]
      end

      def complete_site_setup repo, hook
        site_repository = { name: repo.name, id: repo.id, hook_id: hook.id }
        site.update_attributes(repository: site_repository, processing: false, healthy: true)
      end

      def actor_died actor, reason
        Writefully.logger.info "#{reason.message}"
        Writefully.redis.with { |c| s.sadd "site:#{site.id}:errors", reason.message }
        site.update_attributes(processing: false, healty: false)
      end

      def clear_db_connection!
        ::ActiveRecord::Base.clear_active_connections! if defined?(::ActiveRecord)
      end

    end
  end
end