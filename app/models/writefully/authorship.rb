module Writefully
  class Authorship < ActiveRecord::Base
    belongs_to :user

    has_many :posts
    has_many :owned_sites, class_name: "Writefully::Site", foreign_key: :owner_id

    scope :by_site, -> (site_id) { where(site_id: site_id) }
  end
end
