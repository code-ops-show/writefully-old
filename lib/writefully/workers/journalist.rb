module Writefully
  module Workers
    class Journalist
      include Celluloid
      trap_exit :actor_died

      attr_reader :asset

      def initialize
        # get job from redis queue
        # processes 2 types of jobs write_content and write_assets
        # or both
      end

      def publish_content(index)
        Writefully.logger.info "Processing #{index[:resource]} #{index[:slug]}"

        @pencil = Tools::Pencil.new_link(index, Writefully::Source.site_id)

        # actually we should upload assets first before updating the content in the db
        # it just makes more sense because the content depends on the assets

        written_to_db  = @pencil.future.write
        upload_assets(index) if written_to_db.value
      ensure
        @pencil.terminate
      end

      def upload_assets(index)
        asset = Asset.new(index)
        assets_results = written_assets.map(&:value)
        results = asset.names.map do |name|
          Celluoid::Actor[:pigeons].future.upload(asset.endpoint, asset.path, name)
        end
      end

      def actor_died actor, reason
        Writefully.logger.error "An error occured #{reason.message}"
      end
    end
  end
end