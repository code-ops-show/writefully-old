require 'celluloid'

module Writefully
  class Writer

    attr_reader :resource, :content, :asset, :index

    STORAGE = Storage.new

    class ContentModelNotFound < StandardError; end

    def initialize(index)
      @index    = index
      @content  = Content.new(index)
      @asset    = Asset.new(index)
      @resource = compute_type            
    end

    def write_content 
      object = resource.where(slug: content.slug).first_or_initialize(content.meta)
      object.content = converted_assets_for(content.body)
      object.details = converted_assets_for(content.meta["details"])         
      object.save
    end

    def write_assets
      asset.names.map { |asset_name| store_asset(asset_name) } 
    end

    def store_asset asset_name
      file = File.open(File.join(asset.path, asset_name))
      s3_file = STORAGE.store_file(File.join(asset.endpoint, asset_name), file)
    end

    def converted_assets_for content
      if content.is_a?(String)
        content.gsub(asset.regex, asset.url(STORAGE.endpoint))
      elsif content.is_a?(Hash)
        content.inject({}) do |h, (k, v)| 
          h[k] = v.gsub(asset.regex, asset.url(STORAGE.endpoint)); h 
        end 
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