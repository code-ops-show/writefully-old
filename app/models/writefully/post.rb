module Writefully
  class Post < ActiveRecord::Base
    include Writefully::Postable

    has_many :taggings
    wf_taxonomize :tags, -> { where(type: nil) }, through: :taggings

    belongs_to :authorship

    belongs_to :parent, class_name: "Writefully::Post"

    belongs_to :site

    has_many :translations, class_name: "Writefully::Post", foreign_key: :post_id

    scope :by_site, -> (site_id) { where(site_id: site_id) }

    def details
      Hashie::Mash.new(read_attribute(:details))
    end
  end
end
