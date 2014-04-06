module Writefully
  class Post < ActiveRecord::Base
    include Writefully::Postable

    has_many :taggings
    wf_taxonomize :tags, -> { where(type: nil) }, through: :taggings

    belongs_to :authorship

    belongs_to :parent, class_name: "Writefully::Post"

    def details
      Hashie::Mash.new(read_attribute(:details))
    end
  end
end
