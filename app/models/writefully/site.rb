module Writefully
  class Site < ActiveRecord::Base
    HOOK_EVENTS = %w(push collaborator)

    after_create :setup_repository

    def setup_repository
      # publish a message
    end
  end
end
