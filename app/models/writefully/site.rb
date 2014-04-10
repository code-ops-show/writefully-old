module Writefully
  class Site < ActiveRecord::Base
    HOOK_EVENTS = %w(push collaborator)

    after_create :setup_repository
    belongs_to :owner, class_name: "Writefully::Authorship"

    def setup_repository
      Writefully.redis.publish('mailbox:site_builder:build', self.id)
    end
  end
end
