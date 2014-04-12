module Writefully
  module Workers
    class Journalist
      include Celluloid

      trap_exit :actor_died

      attr_reader :asset, :index

      def perform(message)
        publish_content(message)
      end

      def publish_content(index)
        Writefully.logger.info "Publishing #{index[:resource]} #{index[:slug]}"

        @index = index
        @asset = Asset.new(index)

        assets_uploaded = upload_assets.map(&:value).compact
        write_content if can_update_db?(asset.names, assets_uploaded)
      end

      def write_content
        pencil = Tools::Pencil.new_link(index, Writefully::Source.site_id, asset)
        written_to_db   = pencil.future.write 
        pencil.terminate if written_to_db.value
      end

      def can_update_db?  available, uploaded
        available.count == uploaded.count
      end

      def upload_assets
        asset.names.map do |name|
          Celluloid::Actor[:pigeons].future.upload(asset.endpoint, asset.path, name)
        end
      end

      def actor_died actor, reason
        Writefully.logger.error "An error occured #{reason.message}"
      end
    end
  end
end