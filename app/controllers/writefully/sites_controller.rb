require_dependency "writefully/application_controller"

module Writefully
  class SitesController < ApplicationController
    before_filter :authenticate_wf_owner!

    def index
      @sites = current_wf_owner.owned_sites
      redirect_to new_site_path if @sites.empty?
    end

    def new
      @site = current_wf_owner.owned_sites.build
    end

    def create
      @site = current_wf_owner.owned_sites.build(site_params)
    end

  protected

    def site_params
      params.require(:site).permit(:name, :access_token, :owner, :domain)
    end
  end
end
