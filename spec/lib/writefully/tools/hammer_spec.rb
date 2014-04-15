require 'spec_helper'
require 'celluloid'
require 'writefully/tools'

module Writefully
  module Tools
    describe Hammer do 
      let(:user_name) { 'zacksiri' }
      let(:domain)    { 'http://www.codemy.net' }
      let(:site_name) { 'codemy-net' }
      let(:token)     { 'sampletoken' }

      before do 
        $stdout.stub(:write)
        $stderr.stub(:write)
      end

      describe "#forge" do 
        it "can forge" do 
          Github::Repos.any_instance.stub(:create).and_return(true)
          hammer = Hammer.new token, user_name, site_name, domain
          hammer.forge.should be_true
          hammer.terminate
        end

        it "should raise error" do 
          Github::Repos.any_instance.stub(:create).and_raise(StandardError)
          hammer = Hammer.new token, user_name, site_name, domain
          expect { 
            hammer.forge
          }.to raise_error
        end
      end

      describe "#add_hook_for" do 
        it "should create hook" do
          Github::Repos::Hooks.any_instance.stub(:create).and_return(true)
          hammer = Hammer.new token, user_name, site_name, domain
          hammer.add_hook_for(site_name).should be_true
          hammer.terminate
        end

        it "should raise error" do 
          Github::Repos::Hooks.any_instance.stub(:create).and_raise(StandardError)
          hammer = Hammer.new token, user_name, site_name, domain
          expect { 
            hammer.add_hook_for(site_name)
          }.to raise_error
        end
      end 



    end
  end
end