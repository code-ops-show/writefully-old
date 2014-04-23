module Writefully
  module Workers
    class Handyman < BaseWorker
      include Helpers::Handyman::Builder

      attr_reader :site

      def build
        @site      = Site.where(id: message[:site_id]).first
        @hammer    = Tools::Hammer.new_link(message.merge({ domain: site.domain }))
        # create the repository
        repo = @hammer.future.forge

        # add sample content
        @initializer = Tools::Initializer.new_link(message.merge({ ssh_url: repo.value.ssh_url }))
        initialize_sample_content

        # add web hook
        hook = @hammer.future.add_hook_for(repo.value.name)
        complete_site_setup(repo.value, hook.value)
      ensure
        @hammer.terminate
        @initializer.terminate
        close_db_connection!
      end

      def synchronize
        @synchronizer = Tools::Synchronizer.new_link(message)
        synced = @synchronizer.future.sync
        Writefully.logger.info "Synchronized #{message[:site_slug]}" if synced.value
      ensure
        @synchronizer.terminate
      end

    end
  end
end