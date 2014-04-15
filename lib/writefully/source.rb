module Writefully
  module Source

    class << self
      def content_path
        Writefully.options[:content]
      end

      def models_path
        File.join(Writefully.options[:app_directory], 'app', 'models')
      end

      def to_load
        Dir.chdir(models_path) do 
          Dir.glob('*').select do |file|
            open(File.join(models_path, file)).read.strip.match(/Writefully/) if File.file?(file)
          end.collect { |file| file.split('.')[0] }
        end
      end
    end
  end
end