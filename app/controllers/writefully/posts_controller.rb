require_dependency "writefully/application_controller"

module Writefully
  class PostsController < ApplicationController
    def index
      @site = get_site
      @posts = @site.posts
    end

    def show
      @site = get_site
      @post = @site.posts.friendly.find(params[:id])
    end
    
  protected

    def get_site
      current_wf_authorship.owned_sites.friendly.find(params[:site_id])
    end
  end
end
