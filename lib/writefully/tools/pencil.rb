require 'celluloid'

module Writefully
  module Tools
    class Pencil
      include Celluloid

      finalizer :cleanup

      attr_reader :resource, :content, :asset, :index

      class ContentModelNotFound < StandardError; end

      def initialize(index)
        @index    = index
        @content  = Content.new(index)
        @asset    = Asset.new(index)
        @resource = compute_type            
      end

      def computed_attributes
        content.meta.merge({ 
          content: asset.convert_for(content.body),
          details: asset.convert_for(content.details)
        })
      end

      def write_content 
        resource.where(slug: content.slug)
                  .first_or_initialize
                    .update_attributes(computed_attributes)
      end

      def write_assets
        asset.names.map do |asset_name| 
          Celluloid::Actor[:assets_handler].async.upload(asset.endpoint, asset.path, asset_name)
        end
      end

      def cleanup
        # on termination (success) we need to remove the job from the queue
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