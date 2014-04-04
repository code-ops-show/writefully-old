require 'yaml'

require 'writefully/engine'
require 'activerecord-import'
require 'active_support/core_ext'
require 'hashie'

module Writefully
  class << self

    def options
      @_options ||= config_from(config_yml)
    end

    def env
      ENV["RACK_ENV"] || ENV["RAILS_ENV"] || 'development'
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

require 'writefully/hook'
require 'writefully/taxon'
require 'writefully/asset'
require 'writefully/source'
require 'writefully/writer'
require 'writefully/postable'
require 'writefully/indices'
require 'writefully/content'
require 'writefully/storage'
require 'writefully/messenger'
require 'writefully/repository'