require 'celluloid/zmq'

module Writefully
  class PostOffice
    include Celluloid::ZMQ

    def initialize address
      @socket = PullSocket.new

      begin
        @socket.bind(address)
      rescue IOError
        @socket.close
        raise
      end
    end

    def run
      loop { async.handle_delivery @socket.read }
    end

    def handle_delivery package
      Celluloid::Actor[package[:role].to_sym].async.__send__(package[:method], package[:args])
    end
  end

  class MailMan
    include Celluloid::ZMQ

    def initialize address
      @socket = PushSocket.new

      begin
        @socket.connect(address)
      rescue IOError
        @socket.close
        raise
      end
    end

    def deliver package
      @socket.send(message)
      nil
    end
  end
end