require 'fog'
require 'listen'
require 'logger'
require 'celluloid'
require 'github_api'
require 'active_record'
require 'friendly_id'
require 'activerecord-import'
require 'connection_pool'
require 'redis'
require 'redis-namespace'
require 'writefully/version'
require 'writefully/loader'
require 'writefully/tools'
require 'writefully/workers'
require 'writefully/news_agency'
require 'singleton'

%w(tag post site tagging authorship).each do |model|
  require File.dirname(__FILE__) + "/../../app/models/writefully/#{model}"
end

module Writefully
  class Process
    include Singleton

    attr_reader :config

    def listen config
      @config = config

      set_title
      set_options
      log_start
      load_models
      connect_to_database!
      start_news_agency!
      start_dispatcher!
      boot_listener!
    end

    def set_title
      $0 = "Writefully #{Writefully::VERSION}"
    end

    def set_options
      Writefully.options = config
    end

    def load_models
      Writefully::Source.to_load.each do |model|
        require File.join(config[:app_directory], 'app', 'models', model)
      end
    end

    # connect to db
    def connect_to_database!
      ActiveRecord::Base.establish_connection(Writefully.db_config)
    end

    # Dispatcher monitors job queue and throws job at workers
    def start_dispatcher!
      Tools::Dispatcher.supervise_as :dispatch
      Tools::Retryer.supervise_as    :retryer
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

    # this listener listens to the specified content folder 
    # queues the changes detected into the job queue
    def boot_listener!
      listener = Listen.to config[:content], wait_for_delay: 2, &process_message
      listener.start
      while listener.listen?
        sleep 0.5
      end
    end

    JOBS = { 
      write:  -> (index) { Writefully.add_job :journalists, index.merge({task: :publish}) },
      remove: -> (index) { Writefully.add_job :journalists, index.merge({task: :remove}), :top  }
    }

    def queue_jobs indices, action
      indices.uniq.each { |index| JOBS[action].call(index) if Source.valid_resources.include?(index[:resource]) }
    end

  end
end