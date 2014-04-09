module Writefully
  module Tools
    class Hammer
      include Celluloid

      attr_reader :user_name, :access_token, :repo_name, :api, :domain

      HOOK_CONFIG = -> { 
        { name: 'web',
          events: ["push", "member"],
          active: true,
          config: { 
            url: "#{domain}/writefully/hook"
          }
        }
      }

      def prepare(access_token, user_name, repo_name, domain)
        @domain    = domain
        @user_name = user_name
        @access_token = access_token
        @repo_name  = repo_name
        @api = Github.new oauth_token: access_token
      end

      def forge blk
        result = api.repos.create name: repo_name 
        blk.call(result)
      end

      def add_hook_for blk
        result = api.repos.hooks.create user_name, repo_name, HOOK_CONFIG.call
        blk.call(result)
      end
    end
  end
end