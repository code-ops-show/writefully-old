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

      def initialize api, user_name, site_name, domain
        @api = api
        @user_name = user_name
        @site_name = site_name
        @domain = domain
      end

      def forge
        api.repos.create name: site_name 
      end

      def add_hook_for repo_name
        api.repos.hooks.create user_name, repo_name, HOOK_CONFIG.call(domain)
      end
    end
  end
end