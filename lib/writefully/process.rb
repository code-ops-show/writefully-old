require 'listen'
require 'logger'

require 'celluloid'
require 'celluloid/io'
require 'celluloid/redis'

require 'active_record'
require 'writefully'
require 'redis'
require 'redis-namespace'

%w(tag post site tagging authorship).each do |model|
  require File.dirname(__FILE__) + "/../../app/models/writefully/#{model}"
end

require 'writefully/tools'
require 'writefully/roles'
require 'writefully/news_agency'

module Writefully
  Process = Struct.new(:config) do

    def listen
      log_start
      connect_to_database!
      load_required_models
      start_news_agency!
      boot_listener!
    end


    def connect_to_database!
      ActiveRecord::Base.establish_connection(Writefully.db_config)
    end

    def load_required_models
      Writefully::Source.to_load.each do |model|
        require File.join(Writefully.options[:app_directory], 'app', 'models', model)
      end
    end

    def start_news_agency!
      NewsAgency.run!
    end

    def log_start
      Writefully.logger.info("This is doctor Frasier Crane. I'm listening...")
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
      write:  -> (index) { Celluloid::Actor[:journalist].publish(index) },
      remove: -> (index) { Celluloid::Actor[:censor].pull(index)  }
    }

    def queue_jobs indices, action
      indices.uniq.each { |index| JOBS[action].call(index) }
    end

  end
end