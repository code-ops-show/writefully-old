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
      object.content = converted_body_assets
      object.cover   = get_cover_url
      object.save
    end

    def write_assets
      asset.names.map { |asset_name| store_asset(asset_name) } 
    end

    def store_asset asset_name
      file = File.open(File.join(asset.path, asset_name))
      s3_file = STORAGE.store_file(File.join(asset.endpoint, asset_name), file)
    end

    def converted_body_assets
      file_url = File.join(STORAGE.endpoint, asset.endpoint, '/')
      file_regex = ::Regexp.new('assets\/')
      content.body.gsub(file_regex, file_url)
    end

    def get_cover_url
      File.join(STORAGE.endpoint, asset.endpoint, content.meta["cover"])
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