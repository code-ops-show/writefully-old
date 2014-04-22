module Writefully
  class Site < ActiveRecord::Base
    self.table_name = "writefully_sites"

    extend FriendlyId

    HOOK_EVENTS = %w(push collaborator)

    friendly_id :name, use: :slugged

    after_save :setup_repository, if: -> { repository.nil? }
    after_save :clear_errors,     if: -> { healthy_changed? and healthy? }

    belongs_to :owner, class_name: "Writefully::Authorship"

    has_many :posts, -> { order(:position) }

    def setup_repository
      Writefully.add_job :handyman, { task: :build, auth_token: owner.data["auth_token"], 
                                                    user_name: owner.data["user_name"],
                                                    site_id: id, site_slug: slug   }
    end

    def processing_errors
      Writefully.redis.with { |c| c.smembers "site:#{self.id}:errors" }
    end

    def clear_errors
      Writefully.redis.with { |c| c.del("site:#{self.id}:errors") }
    end
  end
end
