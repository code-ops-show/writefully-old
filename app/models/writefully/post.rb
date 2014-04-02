module Writefully
  class Post < ActiveRecord::Base
    include Writefully::Postable

    has_many :taggings
    wf_taxonomize :tags, -> { where(type: nil) }, through: :taggings
  end
end
