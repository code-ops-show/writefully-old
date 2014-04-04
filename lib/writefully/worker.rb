require 'celluloid'

module Writefully
  class Worker
    include Celluloid

    def write(index)
      writer = Writer.new(index)
      writer.write_content
      writer.write_assets
    end

    def erase(index)
      
    end

    def setup_repository(site_id)
      site = Site.where(id: site_id).first
      repository = Repository.new(site.access_token, site.owner)
    end
  end
end