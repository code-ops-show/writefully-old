module Writefully
  module Roles
    class MailMan
      include Celluloid::IO

      finalizer :shutdown

      def initialize
        r = ::Redis.new(host: 'localhost', port: 6379, driver: :celluloid)
        @redis = ::Redis::Namespace.new(:"#{Writefully.env}:writefully", redis: r)
        subscribe
      end

      def subscribe
        @redis.psubscribe('inbox:*') do |on|
          on.pmessage &async.handle_message
        end 
      end

      def handle_message
        Proc.new do |match, channel, message|
          actor_name, action_name = channel.split(':')[1,2]
          puts actor_name
          puts action_name
          # Celluloid::Actor[actor_name].__send__(action_name, message)
        end
      end

      def exit_redis
        @redis.punsubscribe('inbox:*')
        @redis.quit
      end

      def shutdown
        async.exit_redis
      end
    end
  end
end