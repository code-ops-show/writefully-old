module Writefully
  module Tools
    class Pencil < Stationery

      def use
        assets_uploaded = upload_assets.map(&:value).compact
        written_to_db   = future.write if can_update_db?(assets_uploaded)
        terminate if written_to_db.value
      end

      def computed_attributes
        content.meta.merge({ 
          "content" => asset.convert_for(content.body),
          "details" => asset.convert_for(content.details),
          "trashed" => false
        })
      end

      def write
        compute_type.by_site(site_id).where(slug: content.slug)
                      .first_or_initialize
                        .update_attributes(computed_attributes)
      end
      
      def upload_assets
        asset.names.map do |name|
          Celluloid::Actor[:pigeons].future.upload(asset.endpoint, asset.path, name)
        end
      end

      def can_update_db? uploaded
        if asset.names.count == uploaded.count
          true
        else 
          raise SomeAssetsNotUploaded, "Some assets was not uploaded"
        end
      end
      
    end
  end
end