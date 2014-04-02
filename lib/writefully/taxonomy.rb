module Writefully
  module Taxonomy
    extend ActiveSupport::Concern

    included do
      has_many :taggings
    end

    module ClassMethods
      def writefully_tokenize type
        class_eval do 
          has_many :"#{type}",  through: :taggings
        end
      end

      def ids_from_token tokens
        taxon = Taxon.new(tokens, pluck(:name), name)
    
        import taxonomy.non_existing
        where(name: tokens).ids
      end
    end
  end
end