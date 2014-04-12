module Writefully
  module Tools
    class Pencil
      include Celluloid
      include Celluloid::Logger

      attr_reader :resource, :content, :asset, :index, :site_id, :asset

      class ContentModelNotFound < StandardError; end
      class SomeAssetsNotUploaded < StandardError; end

      def initialize(index, site_id)
        @site_id  = site_id
        @index    = index
        @content  = Content.new(index)
        @asset    = Asset.new(index)
      end

      def perform
        assets_uploaded = upload_assets.map(&:value).compact
        written_to_db   = future.write if can_update_db?(assets_uploaded)
        terminate if written_to_db.value
      end

      def computed_attributes
        content.meta.merge({ 
          content: asset.convert_for(content.body),
          details: asset.convert_for(content.details)
        })
      end

      def write
        compute_type.by_site(site_id).where(slug: content.slug)
                      .first_or_initialize
                        .update_attributes(computed_attributes)
      ensure 
        ::ActiveRecord::Base.clear_active_connections! if defined?(::ActiveRecord)
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

    private

      def compute_type
        index[:resource].classify.constantize
      rescue NameError
        fallback_type
      end

      def fallback_type
        if index[:resource] == "posts"
          "Writefully::Post".constantize
        else 
          raise ContentModelNotFound, "Model #{index[:resource].classify} was not found"
        end
      end
      
    end
  end
end