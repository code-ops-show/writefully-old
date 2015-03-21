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

      let(:hook_config) { 
        { name: 'web',
          events: ["push", "member"],
          active: true,
          config: { 
            url: "http://www.codemy.net/writefully/hook", 
            content_type: 'json',
            secret: '00e4de0cf7647cd447b6659bd0b3b5fe'
          } 
        }
      }

      before do 
        $stdout.stub(:write)
        $stderr.stub(:write)
      end

      describe "#hook_config" do 
        it "should be correct" do 
          hammer = Hammer.new message
          expect(hammer.hook_config).to eq hook_config
          hammer.terminate
        end
      end

      describe "#forge" do 
        it "can forge" do 
          Github::Client::Repos.any_instance.stub(:create).and_return(true)
          hammer = Hammer.new message
          expect(hammer.forge).to be true
          hammer.terminate
        end

        it "should raise error" do 
          Github::Client::Repos.any_instance.stub(:create).and_raise(StandardError)
          hammer = Hammer.new message
          expect { 
            hammer.forge
          }.to raise_error
        end
      end

      describe "#add_hook_for" do 
        it "should create hook" do
          Github::Client::Repos::Hooks.any_instance.stub(:create).and_return(true)
          hammer = Hammer.new message
          expect(hammer.add_hook_for(site_slug)).to be true
          hammer.terminate
        end

        it "should raise error" do 
          Github::Client::Repos::Hooks.any_instance.stub(:create).and_raise(StandardError)
          hammer = Hammer.new message
          expect { 
            hammer.add_hook_for(site_slug)
          }.to raise_error
        end
      end 



    end
  end
end