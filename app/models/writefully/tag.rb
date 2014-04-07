module Writefully
  class Tag < ActiveRecord::Base
    has_many :taggings
    has_many :posts, through: :taggings

    scope :by_site, -> (site_id) { where(site_id: site_id) }

    class << self 
      def ids_from_tokens tokens
        taxon = Taxon.new(tokens, pluck(:name), name)

        import taxon.non_existing
        where(slug: tokens.map { |t| t.parameterize }).ids
      end
    end
  end
end
