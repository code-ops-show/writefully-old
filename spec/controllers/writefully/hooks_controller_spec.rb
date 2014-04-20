require 'spec_helper'

module Writefully
  describe HooksController do 
    routes { Writefully::Engine.routes }

    let(:github_push_hook)       { open(File.dirname(__FILE__) + "/../../fixtures/writefully/github_push_hook.json").read }
    let(:github_member_add_hook) { open(File.dirname(__FILE__) + "/../../fixtures/writefully/github_member_add_hook.json").read }
  
    before do 
      HooksController.any_instance.stub(:check_signature).and_return(true)
    end

    it "should call 'push'" do 
      request.headers["X-Github-Event"] = 'push'
      controller.should_receive(:push).once
      post :create, github_push_hook
      response.should be_success
    end

    it "should call 'member'" do 
      request.headers["X-Github-Event"] = 'member'
      controller.should_receive(:member).once
      post :create, github_member_add_hook
      response.should be_success
    end

    it "should add new authorship" do 
      request.headers["X-Github-Event"] = 'member'
      expect { 
        post :create, github_member_add_hook
      }.to change(Authorship, :count).by(1)
    end
  end 
end