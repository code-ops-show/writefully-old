require 'spec_helper'
require 'celluloid'
require 'writefully/tools'

module Writefully
  module Tools
    describe Hammer do 
      let(:user_name) { 'zacksiri' }
      let(:domain)    { 'http://www.codemy.net' }
      let(:site_slug) { 'codemy-net' }
      let(:token)     { 'sampletoken' }

      let(:message) { {auth_token: token, user_name: user_name, domain: domain, site_slug: site_slug }}

      before do 
        $stdout.stub(:write)
        $stderr.stub(:write)
      end

      describe "#forge" do 
        it "can forge" do 
          Github::Repos.any_instance.stub(:create).and_return(true)
          hammer = Hammer.new message
          hammer.forge.should be_true
          hammer.terminate
        end

        it "should raise error" do 
          Github::Repos.any_instance.stub(:create).and_raise(StandardError)
          hammer = Hammer.new message
          expect { 
            hammer.forge
          }.to raise_error
        end
      end

      describe "#add_hook_for" do 
        it "should create hook" do
          Github::Repos::Hooks.any_instance.stub(:create).and_return(true)
          hammer = Hammer.new message
          hammer.add_hook_for(site_slug).should be_true
          hammer.terminate
        end

        it "should raise error" do 
          Github::Repos::Hooks.any_instance.stub(:create).and_raise(StandardError)
          hammer = Hammer.new message
          expect { 
            hammer.add_hook_for(site_slug)
          }.to raise_error
        end
      end 



    end
  end
end