module Writefully::Workers::Helpers::Handyman
  module Builder
    extend ActiveSupport::Concern

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