require 'spec_helper'

module Writefully
  describe PostsController do 
    routes { Writefully::Engine.routes }

    fixtures :"writefully/sites"
    fixtures :"writefully/posts"
    fixtures :"writefully/authorships"

    let(:owner)  { writefully_authorships(:wf_owner_1) }
    let(:site)   { writefully_sites(:codemy_net) }
    let(:post_1) {  writefully_posts(:hash_selector_pattern) }

    let(:some_post) { writefully_posts(:blah_post) }

    before do 
      session[:wf_authorship_id] = owner.id
    end

    describe "#index" do 
      it "should be success" do 
        get :index, site_id: site.slug
        response.should be_success
      end

      it "should assign correct posts" do 
        get :index, site_id: site.slug
        assigns[:posts].should include post_1
        assigns[:posts].should_not include some_post
      end
    end

    describe "#show" do 
      it "should be success" do 
        get :show, site_id: site.slug, id: post_1.id
        response.should be_success
      end

      it "should assign the correct post" do 
        get :show, site_id: site.slug, id: post_1.id
        assigns[:post].should eq post_1
      end
    end
  end
end