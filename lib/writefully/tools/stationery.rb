module Writefully
  module Tools
    class Stationery
      include Celluloid
      
      attr_reader  :content, :asset, :index, :site_id

      class ContentModelNotFound < StandardError; end
      class SomeAssetsNotUploaded < StandardError; end

      def initialize(index)
        @site_id  = Site.where(slug: index[:site]).first.id
        @index    = index
        @content  = Content.new(index)
        @asset    = Asset.new(index)
      end

      def perform
        use
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