require 'spec_helper'

module Writefully
  describe SitesController do 
    routes { Writefully::Engine.routes }

    fixtures :"writefully/sites"
    fixtures :"writefully/posts"
    fixtures :"writefully/authorships"

    let(:owner) { writefully_authorships(:wf_owner_1) }
    let(:site)  { writefully_sites(:codemy_net) }
    let(:some_site) { writefully_sites(:some_site) }

    before do 
      session[:wf_authorship_id] = owner.id
    end

    describe "#index" do 
      context "when user has sites" do 
        it "should be success" do 
          get :index
          response.should be_success
        end

        it "should assign correct sites" do 
          get :index
          assigns[:sites].should include site
          assigns[:sites].should_not include some_site
        end
      end

      context "when user doesn't have any site" do 
        let(:owner) { writefully_authorships(:wf_owner_2) }

        it "should be redirect" do 
          get :index
          response.should redirect_to(new_site_path)
        end
      end
    end

    describe "#show" do 
      it "should be redirect when no tab specified" do 
        get :show, id: site.slug
        response.should redirect_to(site_posts_path(site))
      end

      it "should be success when correct tab is specified" do 
        get :show, id: site.slug, tab: 'processing'
        response.should be_success
      end

      it "should be redirect when wrong tab is specified" do 
        get :show, id: site.slug, tab: 'weird'
        response.should redirect_to(site_posts_path(site))
      end
    end

    describe "#new" do 
      it "should be success" do 
        get :new
        response.should be_success
      end
    end

    describe "#edit" do 
      it "should be success" do 
        get :edit, id: site.slug
        response.should be_success
      end
    end

    describe "#create" do 
      before do 
        Site.any_instance.stub(:setup_repository).and_return(true)
      end

      it "should create new site" do 
        expect { 
          post :create, site: { name: "New Site", domain: "http://www.newsite.com" }
        }.to change(Site, :count).by(1)
      end 

      it "should be redirect" do 
        post :create, site: { name: "New Site", domain: "http://www.newsite.com" }
        response.should be_redirect
      end
    end
  end
end