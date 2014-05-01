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

          scope :"with_#{type}", -> { select(with_tags_query(type)) }

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

    private

      def with_tags_query type
        posts    = arel_table
        tags     = Tag.arel_table
        taggings = Tagging.arel_table

        tags_for_posts = Tag.joins(:taggings).arel
                            .where(tags[:type].eq(calculate_type(type)))
                            .where(taggings[:post_id].eq(posts[:id])).as('tag')

        tags_as_hstore = tags.project(Arel.sql('hstore(tag)')).from(tags_for_posts)

        array_function = Arel::Nodes::NamedFunction.new('ARRAY', [tags_as_hstore])


        [posts[Arel.star], array_function.as("all_#{type}")]
      end

      def calculate_type type
        type == :tags ? nil : type.to_s.classify 
      end
    end
  end
end