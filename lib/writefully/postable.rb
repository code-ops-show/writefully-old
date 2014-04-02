require 'active_support/core_ext'

module Writefully
  module Postable
    extend ActiveSupport::Concern
    class NoContentField < StandardError ; end

    included do 
      after_initialize :check_content_field_existence
      attr_accessor :publish

      has_many :taggings
      
      before_save :publish_resource, if: -> { respond_to?(:published_at) }
    end

    def taxonomize_with(tokens, type)
      type          = type.to_s.singularize
      type_class    = type.classify
      self.send(:"#{type}_ids=", type_class.constantize.ids_from_tokens(tokens))
    rescue NameError
      self.send(:"#{type}_ids=", "Writefully::#{type_class}".constantize.ids_from_tokens(tokens))
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
    end
  end
end