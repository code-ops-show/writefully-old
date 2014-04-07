module Writefully
  module Source

    class << self

      def content_path
        Writefully.options[:content]
      end

      def site_id
        @site_id ||= open(File.join(content_path, 'site-id')).read.strip.to_i
      end

      def contentable
        (available & valid)
        .collect { |resource| resource.pluralize }
      end

      def available
        Dir.chdir(content_path) do 
          Dir.glob("*").collect { |resource| resource.singularize }
        end
      end

      def valid
        Dir.chdir(Rails.root.join('app', 'models')) do
          Dir.glob('*').select { |model| model.include?('.rb') }
                       .collect { |model| model.split('.')[0] }
        end
      end

      def indices
        contentable.collect do |resource|
          Dir.chdir(File.join(content_path, resource)) do
            Dir.glob('*').collect do |content|
              { resource: resource, slug: content }
            end
          end
        end.flatten(1)
      end
    end

  end
end