module Writefully
  module Tools
    class Pencil
      include Celluloid

      finalizer :clean_up

      attr_reader :resource, :content, :asset, :index, :site_id

      class ContentModelNotFound < StandardError; end

      def pick_up(index, site_id)
        @site_id  = site_id
        @index    = index
        @content  = Content.new(index)
        @asset    = Asset.new(index)
      end

      def computed_attributes
        content.meta.merge({ 
          content: asset.convert_for(content.body),
          details: asset.convert_for(content.details)
        })
      end

      def write_content 
        compute_type.by_site(site_id).where(slug: content.slug)
                      .first_or_initialize
                        .update_attributes(computed_attributes)
      end

      def write_assets
        asset.names.map do |asset_name| 
          Celluloid::Actor[:pigeons].async.upload(asset.endpoint, asset.path, asset_name)
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