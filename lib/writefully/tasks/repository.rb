module Writefully::Tasks
  module Repository
    extend ActiveSupport::Concern
    
    SIGNAL = -> (condition) { 
      lambda do |result|
        condition.signal(result)
      end
    }

    def setup_site(site_id)
      site         = Site.where(id: site_id).first
      repository   = Repository.new(site.access_token, site.owner)
    
      created_repo = create_repository(repository)
      added_hook   = add_hook(repository, created_repo)

      repository.terminate
    end

    def create_repository(repository)
      condition    = Celluloid::Condition.new
      repository.async.create SIGNAL.call(condition)
      condition.wait
    end

    def add_hook(repository, created_repo)
      condition     = Celluloid::Condition.new
      repo_name     = created_repo.name
      repository.async.add_hook_for repo_name SIGNAL.call(condition)
      condition.wait
    end
  end
end