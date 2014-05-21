require 'active_support/concern'

module Writefully
  module Postable
    extend ActiveSupport::Concern
    class NoContentField < StandardError ; end

    included do 
      after_initialize :check_content_field_existence
      attr_accessor :publish

      scope :with_taxonomies, -> (*types) { select(Taxon::EagerLoader.new(self).build(*types)) }

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
        self.published_at = Time.now unless published_at.present?
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

          define_method("all_#{type}") do 
            read_attribute(:"all_#{type}").map { |taxon| Hashie::Mash.new(taxon) }
          end

          define_method("#{type}=") do |tokens|
            self.taxonomize_with(tokens, type)
          end
        end
      end

      def filter_with(filters)
        if filters.present?
          filters.keys.inject(self) do |klass, type| 
            klass.where(id: by_taxonomies(filters[type].split(/,/), type))
          end
        else all end
      end

      def by_taxonomies(taxonomies, type)
        joins(type.to_sym)
        .where(writefully_tags: { slug: taxonomies, 
                                  type: (type == "tags" ? nil : type.classify) })
        .uniq
      end

      def wf_content(field_name)
        class_eval do 
          alias_attribute :content, :"#{field_name}" unless field_name == :content
        end
      end

    end
  end
end