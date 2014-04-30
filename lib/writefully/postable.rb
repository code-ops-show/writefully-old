require 'active_support/concern'

module Writefully
  module Postable
    extend ActiveSupport::Concern
    class NoContentField < StandardError ; end

    included do 
      after_initialize :check_content_field_existence
      attr_accessor :publish

      before_save :publish_resource, if: -> { respond_to?(:published_at) }
    end

    def taxonomize_with(tokens, type)
      type_singular = type.to_s.singularize
      type_klass    = klass_from(type_singular).constantize
      self.send(:"#{type_singular}_ids=", type_klass.ids_from_tokens(tokens))
    end

    def klass_from type_singular
      type_singular == "tag" ? "Writefully::Tag" : type_singular.classify 
    end

    def publish_resource
      if publish
        self.published_at = Time.now
      else
        self.published_at = nil
      end
    end

    def check_content_field_existence
      unless respond_to?(:content)
        raise NoContentField, "No content field defined please define a content field" 
      end
    end

    module ClassMethods
      def wf_taxonomize(type, *args)
        class_eval do 
          has_many :"#{type}", *args

          scope :"with_#{type}", -> { find_by_sql(build_get_tags_query(type)) }

          define_method("#{type}=") do |tokens|
            self.taxonomize_with(tokens, type)
          end
        end
      end

      def wf_content(field_name)
        class_eval do 
          alias_attribute :content, :"#{field_name}" unless field_name == :content
        end
      end

    #private

      def build_get_tags_query type
        array_function = Arel::Nodes::NamedFunction.new('ARRAY', [build_tag_as_hstore_with(type)])
        arel_table.project([Arel.sql('*'), array_function.as('all_tags')])
      end

      def build_tag_as_hstore_with type
        tags = Tag.arel_table

        tags.project(Arel.sql('hstore(tag)'))
            .from(Tag.joins(:posts => :taggings).where(type: calculate_type(type)).arel.as('tag'))
      end

      def select_taxonomy_for type
        "SELECT hstore(tag) FROM(#{select_post_taxonomy_by(type)}) AS tag" 
      end

      def select_post_taxonomy_by type
        "SELECT writefully_tags.name, writefully_tags.slug FROM writefully_tags
        INNER JOIN writefully_taggings ON writefully_tags.id = writefully_taggings.tag_id
        WHERE writefully_tags.type #{calculate_type_sql_for(type)}
        AND writefully_taggings.post_id = writefully_posts.id"
      end

      def calculate_type type
        type == :tags ? nil : type.to_s.classify 
      end
    end
  end
end