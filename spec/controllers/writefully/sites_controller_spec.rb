require 'spec_helper'

module Writefully
  describe SitesController do 
    routes { Writefully::Engine.routes }

    fixtures :"writefully/sites"
    fixtures :"writefully/posts"
    fixtures :"writefully/authorships"

    let(:owner) { writefully_authorships(:wf_owner_1) }

    before do 
      session[:wf_owner_id] = owner.id
    end

    describe "#index" do 
      it "should be success" do 
        get :index
        response.should be_success
      end
    end
  end
end