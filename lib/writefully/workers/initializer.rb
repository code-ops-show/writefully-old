module Writefully
  module Workers
    class Initializer
      include Celluloid

      INITIALIZE_SCRIPT = File.dirname(__FILE__) + "/../../../scripts/initialize.sh"

      attr_reader :message, :api

      def perform(message)
        initialize_site(message)
      end

      def initialize_site(message)
        @message = message
        @api = Github.new oauth_token: message[:auth_token]

        async.add_sample_content
        async.build_content_folder
      end

      def add_sample_content
        Writefully.logger.info "Adding Sample content #{message[:site_slug]}"
        Source.sample_content_paths.each do |path|
          api.repos.contents.create  message[:user_name], 
                                     message[:site_slug], 
                                     path, sample_content_for(path.split('/').last)     
        end
      end

      def build_content_folder
        Writefully.logger.info "Creating content folder #{message[:site_slug]}"
        system("bash #{INITIALIZE_SCRIPT} #{Writefully.options[:content]} #{message[:site_slug]} #{message[:ssh_url]}")
      end

      def sample_content_for file_name
        Source.sample_content_properties(file_name)
      end
    end
  end
end