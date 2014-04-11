module Writefully
  class Site < ActiveRecord::Base
    extend FriendlyId

    HOOK_EVENTS = %w(push collaborator)

    friendly_id :name, use: :slugged

    after_save :setup_repository, if: -> { repository.nil? }
    after_save :clear_errors,     if: -> { healthy_changed? and healthy? }

    belongs_to :owner, class_name: "Writefully::Authorship"

    has_many :posts, -> { order(:position) }

    def setup_repository
      Writefully.redis.publish('mailbox:site_builder:build', self.id)
    end

    def processing_errors
      Writefully.redis.smembers "site:#{self.id}:errors"
    end

    def clear_errors
      Writefully.redis.del("site:#{self.id}:errors")
    end
  end
end
