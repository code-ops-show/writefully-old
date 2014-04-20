require 'spec_helper'
require 'celluloid'
require 'writefully/tools'
require 'writefully/workers'

module Writefully
  module Workers
    describe Handyman do 
      fixtures :"writefully/sites"

      let(:message) { { task: :build,  user_name: 'zacksiri', auth_token: 'sampletoken', 
                                       site_slug: 'codemy-net', ssh_url: 'blah@blah.com:zacksiri/blah.git', site_id: site.id } }

      let(:repo) { double("repo", :name => 'codemy-net', :ssh_url => 'blah@blah.com:zacksiri/blah.git', :id => "1234") }
      let(:hook) { double("hook", :id => '123') }
      let(:site) { writefully_sites(:codemy_net) }

      before do 
        $stdout.stub(:write)
        $stderr.stub(:write)
        Tools::Hammer.any_instance.stub(:forge).and_return(repo)
        Tools::Hammer.any_instance.stub(:add_hook_for).with('codemy-net').and_return(hook)
        Handyman.any_instance.stub(:initialize_sample_content).and_return([true, true])
      end

      it "should successfully setup site" do 
        handyman = Handyman.new
        handyman.perform(message)
        site.reload.repository.should_not be_nil
        handyman.terminate
      end 
    end
  end 
end