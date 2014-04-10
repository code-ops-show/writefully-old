module Writefully
  module Tools
    class Hammer
      include Celluloid

      attr_reader :api, :user_name, :site_name, :domain

      HOOK_CONFIG = 
        -> (domain) {{ 
          name: 'web',
          events: ["push", "member"],
          active: true,
          config: { url: "#{domain}/writefully/hook" }    
        }}

      def initialize auth_token, user_name, site_name, domain
        @api = Github.new oauth_token: auth_token
        @user_name = user_name
        @site_name = site_name
        @domain = domain
      end

      def forge
        Writefully.logger.info "Forging #{site_name}"
        api.repos.create name: site_name 
      rescue Exception => e
        raise e
      end

      def add_hook_for repo_name
        Writefully.logger.info "Adding hook for #{site_name}"
        api.repos.hooks.create user_name, repo_name, HOOK_CONFIG.call(domain)
      rescue Exception => e
        raise e
      end
    end
  end
end