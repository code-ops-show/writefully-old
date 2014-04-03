require 'listen'
require 'logger'

require 'writefully/worker'

module Writefully
  Monitor = Struct.new(:config) do

    def logger
      @logger ||= Logger.new(log_location)
    end

    def log_location
      Writefully.env == 'development' ? STDOUT : config[:logfile]
    end

    def listen
      log_start
      worker_pool 
      boot_listner
    end

    def log_start
      logger.info("This is doctor Frasier Crane. I'm listening...")
    end

    def boot_listner
      listener = Listen.to config[:content], wait_for_delay: 4, &process_message
      listener.start
      while listener.listen?
        sleep 0.5
      end
    end

    def worker_pool
      @_pool ||= Worker.pool
    end

    def process_message
      Proc.new do |modified, added, removed|
        Indices.build_from(modified).each do |index|
          worker_pool.async.write(index)
        end
      end
    end

  end
end