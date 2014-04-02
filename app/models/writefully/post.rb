module Writefully
  class Post < ActiveRecord::Base
    include Writefully::Postable

    writefully_taxonomize :tags, -> { where(type: nil) }, through: :taggings
  end
end
