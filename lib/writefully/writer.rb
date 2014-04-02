require 'celluloid'

module Writefully
  class Writer

    attr_reader :resource, :content, :asset, :index

    STORAGE = Storage.new

    def initialize(index)
      @content  = Content.new(index)
      @asset    = Asset.new(index)
      @resource = index[:resource].classify.constantize             
    end

    def write_content 
      resource.where(slug: content.slug).first_or_create(content.meta) do |object|
        object.content = converted_body_assets
        object.cover   = get_cover_url
      end 
    end

    def write_assets
      asset.names.map { |asset_name| store_asset(asset_name) } 
    end

    def store_assets asset_name
      file = File.open(File.join(asset.path, asset_name))
      s3_file = STORAGE.store_file(File.join(asset.endpoint, asset_name), file)
    end

    def content_is_different?
      resource.new_record? and (resource.content != content.body)
    end

    def converted_body_assets
      file_url = File.join(STORAGE.endpoint, asset.endpoint)
      file_regex = ::Regexp.new('assets\/')
      content.body.gsub(file_regex, file_url)
    end

    def get_cover_url
      File.join(STORAGE.endpoint, asset.endpoint, content.meta["cover"])
    end
    
  end
end