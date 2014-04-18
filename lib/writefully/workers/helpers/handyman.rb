module Writefully::Workers::Helpers
  module Handyman
    extend ActiveSupport::Concern

    def build_repository
      created_repo = @hammer.future.forge
      added_hook   = @hammer.future.add_hook_for(created_repo.value.name)

      [created_repo.value, added_hook.value]
    end

    def complete_site_setup repo, hook
      site_repository = { name: repo.name, id: repo.id, hook_id: hook.id }
      site.update_attributes(repository: site_repository, processing: false, healthy: true)
    end

    def initialize_sample_content
      added_sample_content = @initializer.future.add_sample_content
      created_directory    = @initializer.future.build_content_folder

      [added_sample_content.value, created_directory.value]
    end
  end
end