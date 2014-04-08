module Writefully
  module ApplicationHelper

    def from_scratch?
      Authorship.count == 0 && Site.count == 0
    end
  end
end