require 'spec_helper'

module Writefully
  describe SitesController, type: :controller do 
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
          expect(response).to be_success
        end

        it "should assign correct sites" do 
          get :index
          expect(assigns[:sites]).to include site
          expect(assigns[:sites]).to_not include some_site
        end
      end

      context "when user doesn't have any site" do 
        let(:owner) { writefully_authorships(:wf_owner_2) }

        it "should be redirect" do 
          get :index
          expect(response).to redirect_to(new_site_path)
        end
      end
    end

    describe "#show" do 
      it "should be redirect when no tab specified" do 
        get :show, id: site.slug
        expect(response).to redirect_to(site_posts_path(site))
      end

      it "should be success when correct tab is specified" do 
        get :show, id: site.slug, tab: 'processing'
        expect(response).to be_success
      end

      it "should be redirect when wrong tab is specified" do 
        get :show, id: site.slug, tab: 'weird'
        expect(response).to redirect_to(site_posts_path(site))
      end
    end

    describe "#new" do 
      it "should be success" do 
        get :new
        expect(response).to be_success
      end
    end

    describe "#edit" do 
      it "should be success" do 
        get :edit, id: site.slug
        expect(response).to be_success
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
        expect(response).to be_redirect
      end
    end
  end
end