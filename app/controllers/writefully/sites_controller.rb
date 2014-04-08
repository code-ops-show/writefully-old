require_dependency "writefully/application_controller"

module Writefully
  class SitesController < ApplicationController
    before_filter -> { redirect_to setup_path }, if: :from_scratch?

    def index
      @sites = Site.all
    end

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
