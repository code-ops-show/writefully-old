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

        @initializer = Tools::Initializer.new_link(message.merge({ ssh_url: repo.ssh_url }))
        initialize_sample_content
      ensure
        @hammer.terminate
        @initializer.terminate
        clear_db_connection!
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

      def initialize_sample_content
        added_sample_content = @initializer.future.add_sample_content
        created_directory    = @initializer.future.build_content_folder

        [added_sample_content.value, created_directory.value]
      end

      def actor_died actor, reason
        Writefully.logger.info "#{reason.message}"
        Writefully.redis.with { |c| s.sadd "site:#{site.id}:errors", reason.message }
        site.update_attributes(processing: false, healty: false)
      end

    end
  end
end