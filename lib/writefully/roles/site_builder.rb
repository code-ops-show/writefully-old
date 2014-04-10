module Writefully
  module Roles
    class SiteBuilder
      include Celluloid

      attr_accessor :user_name, :site_name, :api, :hook_config

      HOOK_CONFIG = -> (domain) { 
        { name: 'web',
          events: ["push", "member"],
          active: true,
          config: { 
            url: "#{domain}/writefully/hook"
          }
        }
      }

      def build(site_id)
        site         = Site.where(id: site_id.to_i).first
        @user_name    = site.owner.data["user_name"]
        @site_name    = site.name.parameterize
        @hook_config  = HOOK_CONFIG.call(site.domain)

        @api = Github.new oauth_token: site.owner.data["auth_token"]

        created_repo = future.create_repository
        added_hook   = future.add_hook_for(created_repo.value.name)
      end

      def create_repository 
        Writefully.logger.info "Forging #{site_name}"
        api.repos.create name: site_name 
      end

      def add_hook_for repo_name
        Writefully.logger.info "Adding hook for #{repo_name}"
        api.repos.hooks.create user_name, repo_name, hook_config
      end

    end
  end
end