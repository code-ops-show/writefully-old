require_dependency "writefully/application_controller"

module Writefully
  class ProfilesController < ApplicationController
    before_filter :authenticate_wf_authorship!


    def edit
      @authorship = current_wf_authorship
    end
  end
end
