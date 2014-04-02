module Writefully
  class Tag < ActiveRecord::Base
    include Writefully::Taxonomy

    has_many :posts, through: :taggings
  end
end
