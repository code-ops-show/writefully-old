require 'celluloid/zmq'

module Writefully
  class PostOffice
    include Celluloid::ZMQ

    def initialize
      
    end

    def on_delivery
      
    end
  end

  class MailMan
    include Celluloid::ZMQ

    def initialize
      
    end

    def deliver package
      
    end
  end
end