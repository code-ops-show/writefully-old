module Writefully
  module Roles
    class MailMan
      include Celluloid::IO

      class InvalidMessage < StandardError; end

      finalizer :shutdown

      MAILBOX_NAME = 'mailbox:*'

      def initialize
        r = ::Redis.new(host: 'localhost', port: 6379, driver: :celluloid)
        @redis = ::Redis::Namespace.new(:"#{Writefully.env}:writefully", redis: r)
        async.subscribe
      end

      def subscribe
        @redis.psubscribe(MAILBOX_NAME) do |on|
          on.pmessage do |match, channel, message|
            async.handle_message(channel, message)            
          end
        end 
      end

      def handle_message(channel, message)
        actor_name, action_name = get_actor_action(channel)
        Celluloid::Actor[actor_name].__send__(action_name, message)
      end

      def get_actor_action(channel)
        channel_descriptor = channel.split(':')
        unless channel_descriptor.count == 5
          raise InvalidMessage, "Need Actor name and Action name #{MAILBOX_NAME}:actor_name:action_name" 
        end
        channel_descriptor[3, 4]
      end

      def shutdown
        @redis.punsubscribe(MAILBOX_NAME)
        @redis.disconnect
      end
    end
  end
end