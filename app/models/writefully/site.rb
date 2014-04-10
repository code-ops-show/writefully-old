module Writefully
  class Site < ActiveRecord::Base
    HOOK_EVENTS = %w(push collaborator)

    after_save :setup_repository, if: -> { repository.nil? }
    after_save :clear_errors,     if: -> { healthy_changed? and healthy? }

    belongs_to :owner, class_name: "Writefully::Authorship"

    def setup_repository
      Writefully.redis.publish('mailbox:site_builder:build', self.id)
    end

    def errors
      Writefully.redis.lrange "site:#{self.id}:errors", 0, 6
    end

    def clear_errors
      Writefully.redis.del("site:#{self.id}:errors")
    end
  end
end
