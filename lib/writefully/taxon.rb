module Writefully
  class Taxon
    attr_reader :incoming, :existing, :type

    def initialize(incoming, existing, type)
      @incoming = incoming
      @existing = existing
      @type     = type
    end

    def non_existing
      get_difference.map { |token| Tag.new(build_attributes(token)) }
    end

    def selector
      @selector ||= type.underscore.to_sym
    end

    def get_difference
      (parameterized(incoming) - parameterized(existing)).map { |t| t.titleize }
    end

    def type_attribute 
      selector == :'writefully/tag' ? { type: nil } : { type: selector.to_s.classify }
    end

    def build_attributes token
      type_attribute
        .merge({ name: token, slug: token.parameterize })
    end

    def parameterized items
      items.map { |t| t.parameterize }
    end

    class EagerLoader
      attr_reader :tags, :taggings, :resource

      def initialize(klass)
        @tags      = Tag.arel_table
        @taggings  = Tagging.arel_table
        @resource  = klass.arel_table
      end

      def build *types
        [resource[Arel.star]] << types.map { |type| array_of_taxonomy_hstores_for(type) }
      end

    private

      def array_of_taxonomy_hstores_for type
        Arel::Nodes::NamedFunction.new('ARRAY', [hstore_for_taxonomy(type)]).as("all_#{type}")
      end

      def hstore_for_taxonomy type
        tags.project(Arel.sql('hstore(taxonomy)')).from(taxonomy_for_resource(type))
      end

      def taxonomy_for_resource type
        Tag.joins(:taggings).arel.where(tags_by_type(type))
                                 .where(taggings_by_resource).as('taxonomy')
      end

      def tags_by_type type
        tags[:type].eq(calculate_type(type))
      end

      def taggings_by_resource
        # we use post_id for now but we should 
        # make it a polymorphic association later
        taggings[:post_id].eq(resource[:id])
      end

      def calculate_type type
        type == :tags ? nil : type.to_s.classify 
      end
    end
  end
end