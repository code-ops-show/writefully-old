require 'github_api'

module Writefully
  module Tools
    class Hammer
      include Celluloid

      attr_reader :owner, :access_token

      def prepare(access_token, owner)
        @owner = owner
        @access_token = access_token
      end

      def api
        Github.new oauth_token: access_token
      end

      def create blk
        result = # call github api 
        blk.call(result)
      end

      def add_hook_for repo_name, blk
        result = # call githut api
        blk.call(result)
      end
    end
  end
end