module Writefully
  module Roles
    class SiteBuilder
      include Celluloid

      SIGNAL = -> (condition) { 
        lambda do |result|
          condition.signal(result)
        end
      }

      def initialize
        @hammer = Celluloid::Actor[:hammer]
        link @hammer
      end

      def build(site_id)
        site         = Site.where(id: site_id).first
        auth_token   = site.owner.data["auth_token"]
        user_name    = site.owner.data["user_name"]
        repo_name    = site.name.parameterize

        @hammer.prepare auth_token, user_name, repo_name, site.domain

        created_repo = create_repository
        added_hook   = add_hook

        binding.pry
      end

      private

      def create_repository
        condition    = Celluloid::Condition.new
        @hammer.async.forge SIGNAL.call(condition)
        condition.wait
      end

      def add_hook
        condition     = Celluloid::Condition.new
        @hammer.async.add_hook_for SIGNAL.call(condition)
        condition.wait
      end

    end
  end
end