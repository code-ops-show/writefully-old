require 'listen'
require 'logger'
require 'celluloid'

require 'active_record'
require 'writefully'

require 'writefully/tools'
require 'writefully/roles'
require 'writefully/news_agency'

module Writefully
  Process = Struct.new(:config) do

    def logger
      @logger ||= Logger.new(log_location)
    end

    def log_location
      Writefully.env == 'development' ? STDOUT : config[:logfile]
    end

    def listen
      log_start
      init_zmq
      connect_to_database!
      load_required_models
      start_post_office!
      start_news_agency!
      boot_listener!
    end

    def connect_to_database!
      # active record connect
    end

    def load_required_models
      
    end

    def init_zmq
      Celluloid::ZMQ.init
    end

    def start_post_office!
      
    end

    def start_news_agency!
      NewsAgency.run!
    end

    def log_start
      logger.info("This is doctor Frasier Crane. I'm listening...")
    end

    def process_message
      Proc.new do |modified, added, removed|
        queue_jobs(Indices.build_from(modified), :write)
        queue_jobs(Indices.build_from(added),    :write)
        queue_jobs(Indices.build_from(removed),  :remove)
      end
    end

    def boot_listener!
      listener = Listen.to config[:content], wait_for_delay: 2, &process_message
      listener.start
      while listener.listen?
        sleep 0.5
      end
    end

    JOBS = { 
      write:  -> (index) { write_or_update(index) },
      remove: -> (index) { remove(index)  }
    }

    def write_or_update index
      logger.info "Processing #{index[:resource]} #{index[:slug]}"
      Celluloid::Actor[:journalist].async.publish(index)
    end

    def remove index
      logger.info "Removing #{index[:resource]} #{index[:slug]}"
      Celluloid::Actor[:censor].async.pull(index)
    end

    def queue_jobs indices, action
      indices.uniq.each { |index| JOBS[action].call(index) }
    end

  end
end