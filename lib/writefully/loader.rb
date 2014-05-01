require 'writefully/storage'
require 'erb'

module Writefully
  SCOPES  = %w(repo public_repo user write:repo_hook)

  class << self

    def options=(config)
      @_options = config
    end

    def options
      @_options ||= config_from(config_yml)
    end

    def redis
      r = Redis.new(host: 'localhost', port: 6379)
      @_redis ||= ConnectionPool.new(size: 5, timeout: 5) do 
        Redis::Namespace.new(:"#{env}:writefully", redis: r)
      end
    end

    def add_job worker, message
      Writefully.redis.with { |c| c.rpush "jobs", convert_job(worker, message) }
    end

    def convert_job worker, message
       Marshal.dump({worker: worker, message: message})
    end

    def env
      ENV["RACK_ENV"] || ENV["RAILS_ENV"] || 'development'
    end

    def github_app
      @_github_app ||= Github.new(client_id:     options[:github_client], 
                                  client_secret: options[:github_secret])
    end

    def logger
      @logger ||= Logger.new(log_location)
    end

    def log_location
      env == 'development' ? STDOUT : Writefully.options[:logfile]
    end

    def db_config
      YAML::load(ERB.new(IO.read(File.join(options[:app_directory], 'config', 'database.yml'))).result)[env]
    end

    def config_from(path = nil)
      YAML::load(ERB.new(IO.read(path)).result)[env]
    rescue Errno::ENOENT
      $stdout.puts "config/writefully.yml does not exist"
    end


    def config_yml
      Rails.root.join('config', 'writefully.yml') if defined?(Rails)
    end

  end
end

require 'writefully/taxon'
require 'writefully/asset'
require 'writefully/source'
require 'writefully/postable'
require 'writefully/indices'
require 'writefully/content'