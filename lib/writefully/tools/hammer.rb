module Writefully
  module Tools
    class Hammer
      include Celluloid

      attr_reader :api, :user_name, :site_name, :domain


      def initialize auth_token, user_name, site_name, domain
        @api = Github.new oauth_token: auth_token
        @user_name = user_name
        @site_name = site_name
        @domain = domain
      end

      def hook_config
        { name: 'web',
          events: ["push", "member"],
          active: true,
          config: { url: "#{domain}/writefully/hook" } }
      end

      def forge
        Writefully.logger.info "Forging #{site_name}"
        api.repos.create name: site_name, auto_init: true
      rescue Exception => e
        raise e
      end

      def add_hook_for repo_name
        Writefully.logger.info "Adding hook for #{site_name}"
        api.repos.hooks.create user_name, repo_name, hook_config
      rescue Exception => e
        raise e
      end

      def add_sample_content repo_name
        Writefully.logger.info "Adding Sample content #{site_name}"

      rescue Exception => e
        raise e
      end
    end
  end
end