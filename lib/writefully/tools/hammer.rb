module Writefully
  module Tools
    class Hammer
      include Celluloid

      attr_reader :api, :message

      def initialize message
        @message = message
        @api = Github.new oauth_token: message[:auth_token]
      end

      def hook_config
        { name: 'web',
          events: ["push", "member"],
          active: true,
          config: { url: "#{message[:domain]}/writefully/hook" } }
      end

      def forge
        Writefully.logger.info "Forging #{message[:site_slug]}"
        api.repos.create name: message[:site_slug], auto_init: true
      rescue Exception => e
        raise e
      end

      def add_hook_for repo_name
        Writefully.logger.info "Adding hook for #{message[:site_slug]}"
        api.repos.hooks.create message[:user_name], repo_name, hook_config
      rescue Exception => e
        raise e
      end

    end
  end
end