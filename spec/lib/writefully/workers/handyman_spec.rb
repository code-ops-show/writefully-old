require 'spec_helper'
require 'celluloid'
require 'writefully/tools'
require 'writefully/workers'

module Writefully
  module Workers
    describe Handyman do 
      fixtures :"writefully/sites"

      let(:build_message) { { task: :build,  user_name: 'zacksiri', auth_token: 'sampletoken', 
                                       site_slug: 'codemy-net', site_id: site.id } }

      let(:repo_value) { double("repo_value", :name => 'codemy-net', :ssh_url => 'blah@blah.com:zacksiri/blah.git', :id => "1234") }                                 
      let(:hook_value) { double("hook_value", :id => "123") }   
      let(:repo) { double("repo", :value => repo_value) }
      let(:hook) { double("hook", :value => hook_value) }
      let(:hammer_future) { double("hammer_future", :forge => repo, :add_hook_for => hook) }
      let(:hammer) { double("Hammer", :future => hammer_future, :terminate => true) } 


      let(:initializer) { double("Initializer", :terminate => true) }                                

      let(:site) { writefully_sites(:codemy_net) }

      before do 
        $stdout.stub(:write)
        $stderr.stub(:write)
        Tools::Hammer.stub(:new_link).and_return(hammer)
        Tools::Initializer.stub(:new_link).and_return(initializer)
        Handyman.any_instance.stub(:initialize_sample_content).and_return([true, true])
      end

      it "should successfully setup site" do 
        handyman = Handyman.new
        handyman.perform(build_message)


        s = site.reload
        expect(s.repository["name"]).to eq 'codemy-net'
        expect(s.repository["id"]).to eq '1234'
        expect(s.repository["hook_id"]).to eq '123'
        expect(s.healthy).to be true
        expect(s.processing).to be false

        handyman.terminate
      end 
    end
  end 
end