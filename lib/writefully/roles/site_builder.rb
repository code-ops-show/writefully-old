module Writefully
  module Roles
    class SiteBuilder
      include Celluloid

      attr_reader :site, :site_name

      trap_exit :handle_error

      def build(site_id)
        @site         = Site.where(id: site_id.to_i).first
        user_name    = site.owner.data["user_name"]

        @site_name     = site.name.parameterize
        api = Github.new oauth_token: site.owner.data["auth_token"]
        @hammer = Tools::Hammer.new_link(api, user_name, site_name, site.domain)
        
        complete_site_setup(*build_repository)
      ensure
        @hammer.terminate
        clear_db_connection!
      end

      def build_repository
        Writefully.logger.info "Forging #{site_name}"
        created_repo = @hammer.future.forge

        Writefully.logger.info "Adding hook for #{site_name}"
        added_hook   = @hammer.future.add_hook_for(created_repo.value.name)

        [created_repo.value, added_hook.value]
      end

      def complete_site_setup repo, hook
        site_repository = { name: repo.name, id: repo.id, hook_id: hook.id }
        site.update_attributes(repository: site_repository, processing: false)
      end

      def handle_error actor, reason
        
      end

      def clear_db_connection!
        ::ActiveRecord::Base.clear_active_connections! if defined?(::ActiveRecord)
      end

    end
  end
end