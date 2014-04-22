module Writefully
  class Post < ActiveRecord::Base
    self.table_name = "writefully_posts"

    extend FriendlyId
    include Writefully::Postable

    friendly_id :title, use: :slugged

    has_many :taggings
    wf_taxonomize :tags, -> { where(type: nil) }, through: :taggings

    belongs_to :authorship
    belongs_to :translation_source, class_name: "Writefully::Post"
    belongs_to :site

    has_many :translations, class_name: "Writefully::Post", foreign_key: :translation_source_id

    scope :by_site, -> (site_id) { where(site_id: site_id) }

    def details
      Hashie::Mash.new(read_attribute(:details))
    end
  end
end
