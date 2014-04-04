module Writefully
  class Site < ActiveRecord::Base
    HOOK_EVENTS = %w(push collaborator)
  end
end
