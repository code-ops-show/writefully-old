module Writefully
  class Post < ActiveRecord::Base
    include Writefully::Postable

    wf_taxonomize :tags, -> { where(type: nil) }, through: :taggings
  end
end
