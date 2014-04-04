require_dependency "writefully/application_controller"

module Writefully
  class SitesController < ApplicationController
    
    def new
      @site = Site.new
    end

    def create
      @site = Site.new(site_params)
    end

  protected

    def site_params
      params.require(:site).permit(:name, :access_token, :owner, :domain)
    end
  end
end
