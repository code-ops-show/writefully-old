module Writefully
  module Workers
    class Handyman < BaseWorker
      include Helpers::Handyman::Builder

      attr_reader :site

      def build
        @site      = Site.where(id: message[:site_id]).first
        @hammer    = Tools::Hammer.new(message.merge({ domain: site.domain }))

        # create the repository
        repo = @hammer.forge

        # add sample content
        @initializer = Tools::Initializer.new(message.merge({ ssh_url: repo.ssh_url }))
        initialize_sample_content

        # add web hook
        hook = @hammer.add_hook_for(repo.name)
        complete_site_setup(repo, hook)
      ensure
        close_db_connection!
      end

      def synchronize
        @synchronizer = Tools::Synchronizer.new(message)
        synced = @synchronizer.sync
        Writefully.logger.info "Synchronized #{message[:site_slug]}"
      end

      def on_death actor, reason
        if site
          Writefully.redis.with { |c| s.sadd "site:#{site.id}:errors", reason.message }
          site.update_attributes(processing: false, healty: false)
        end
      end

    end
  end
end