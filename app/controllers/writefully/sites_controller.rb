require_dependency "writefully/application_controller"

module Writefully
  class SitesController < ApplicationController
    before_filter :authenticate_wf_owner!

    VALID_TABS = %w(processing errors)

    def index
      @sites = current_wf_owner.owned_sites
      redirect_to new_site_path if @sites.empty?
    end

    def show
      @site = get_site
      if params[:tab].nil? or not tab_valid?
        redirect_to site_posts_path(@site) 
      end
    end

    def new
      @site = current_wf_owner.owned_sites.build
    end

    def edit
      @site = get_site
    end

    def create
      @site = current_wf_owner.owned_sites.build(site_params)
      if @site.save
        set_flash :success, object: @site
        redirect_to sites_path
      end
    end

  protected

    def tab_valid?
      VALID_TABS.include?(params[:tab])
    end

    def get_site
      current_wf_owner.owned_sites.friendly.find(params[:id])
    end

    def site_params
      params.require(:site).permit(:name, :domain)
    end
  end
end
