module Writefully
  class Tag < ActiveRecord::Base
    has_many :taggings
    has_many :posts, through: :taggings

    class << self 
      def ids_from_tokens tokens
        taxon = Taxon.new(tokens, pluck(:name), name)
    
        import taxon.non_existing
        where(name: tokens).ids
      end
    end
  end
end
