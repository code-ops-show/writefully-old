require_dependency "writefully/application_controller"

module Writefully
  class SetupsController < ApplicationController
    def show
      @authorship = Authorship.new
    end
  end
end
