require 'github_api'
require 'celluloid'

module Writefully
  class Repository
    def api
      @_api ||= ::Github.new
    end

    def create
      
    end

    def add_hook
      
    end
  end
end