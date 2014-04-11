module Writefully
  module Tools
    class Pencil
      include Celluloid
      include Celluloid::Logger

      finalizer :clean_up

      attr_reader :resource, :content, :asset, :index, :site_id

      class ContentModelNotFound < StandardError; end

      def initialize(index, site_id)
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

      def write
        compute_type.by_site(site_id).where(slug: content.slug)
                      .first_or_initialize
                        .update_attributes(computed_attributes)
      ensure 
        ::ActiveRecord::Base.clear_active_connections! if defined?(::ActiveRecord)
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