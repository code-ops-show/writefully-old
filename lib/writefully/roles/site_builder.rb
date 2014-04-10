module Writefully
  module Roles
    class SiteBuilder
      include Celluloid

      trap_exit :actor_died

      attr_reader :site, :site_name

      def build(site_id)
        @site      = Site.where(id: site_id.to_i).first
        user_name  = site.owner.data["user_name"]
        auth_token = site.owner.data["auth_token"]

        @site_name = site.name.parameterize
        @hammer    = Tools::Hammer.new_link(auth_token, user_name, site_name, site.domain)

        complete_site_setup(*build_repository)
      ensure
        @hammer.terminate
        clear_db_connection!
      end

      def build_repository
        created_repo = @hammer.future.forge
        added_hook   = @hammer.future.add_hook_for(created_repo.value.name)

        [created_repo.value, added_hook.value]
      end

      def complete_site_setup repo, hook
        site_repository = { name: repo.name, id: repo.id, hook_id: hook.id }
        site.update_attributes(repository: site_repository, processing: false)
      end

      def actor_died actor, reason
        Writefully.logger.info "#{reason.message}"
        site.update_attributes(processing: false, healty: false)
        Writefully.redis.lpush "site:#{site.id}:errors", reason.message
      end

      def clear_db_connection!
        ::ActiveRecord::Base.clear_active_connections! if defined?(::ActiveRecord)
      end

    end
  end
end