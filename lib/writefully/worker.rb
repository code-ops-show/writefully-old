
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

    def setup_site(site_id)
      site         = Site.where(id: site_id).first
      repository   = Repository.new(site.access_token, site.owner)
    
      created_repo = create_repository(repository)
      added_hook   = add_hook(repository, created_repo)

      repository.terminate
    end

    def create_repository(repository)
      condition    = Celluloid::Condition.new
      repository.async.create { |result| condition.signal(result) }
      condition.wait
    end


    def add_hook(repository, created_repo)
      condition     = Celluloid::Condition.new
      repository.async.add_hook(#repo_name) { |result| condition.signal(result) }
      condition.wait
    end
  end
end