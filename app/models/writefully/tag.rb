module Writefully
  class Tag < ActiveRecord::Base
    self.table_name = "writefully_tags"

    has_many :taggings
    has_many :posts, through: :taggings

    class << self 
      def ids_from_tokens tokens
        taxon = Taxon.new(tokens, pluck(:name), name)

        import taxon.non_existing
        where(slug: tokens.map { |t| t.parameterize }).ids
      end
    end
  end
end
