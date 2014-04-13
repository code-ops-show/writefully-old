require 'listen'
require 'logger'

require 'celluloid'

require 'active_record'
require 'writefully'
require 'redis'
require 'redis-namespace'

%w(tag post site tagging authorship).each do |model|
  require File.dirname(__FILE__) + "/../../app/models/writefully/#{model}"
end

Writefully::Source.to_load.each do |model|
  require File.join(Writefully.options[:app_directory], 'app', 'models', model)
end

require 'github_api'

require 'writefully/tools'
require 'writefully/workers'
require 'writefully/news_agency'

module Writefully
  Process = Struct.new(:config) do

    def listen
      log_start
      connect_to_database!
      start_news_agency!
      start_dispatcher!
      boot_listener!
    end

    # connect to db
    def connect_to_database!
      ActiveRecord::Base.establish_connection(Writefully.db_config)
    end

    # Mail Man uses celluloid/io its basically listening for redis subscription
    def start_dispatcher!
      Tools::Dispatcher.supervise_as :dispatch
    end

    # Supervises the actors that manage all the work with converting content
    # and sorting it into its place
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

    # this listener listens to the specified content folder and updates the content
    # in the database
    def boot_listener!
      listener = Listen.to config[:content], wait_for_delay: 2, &process_message
      listener.start
      while listener.listen?
        sleep 0.5
      end
    end

    JOBS = { 
      write:  -> (index) { Writefully.add_job :journalists, index },
      remove: -> (index) { Wrotefully.add_job :censors, index  }
    }

    def queue_jobs indices, action
      indices.uniq.each { |index| JOBS[action].call(index) }
    end

  end
end