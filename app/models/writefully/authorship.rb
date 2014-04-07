module Writefully
  class Authorship < ActiveRecord::Base
    belongs_to :user
    belongs_to :site
    has_many :posts

    scope :by_site, -> (site_id) { where(site_id: site_id) }
  end
end
