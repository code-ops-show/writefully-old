require 'spec_helper'
require 'celluloid'
require 'writefully/tools'

module Writefully
  module Tools
    describe Initializer do 
      let(:message) { { user_name: "zacksiri", auth_token: 'sampletoken', site_slug: 'codemy-net', ssh_url: 'blah@blah.com:zacksiri/blah.git' } }
      let(:command) { "bash /Users/zacksiri/Repositories/writefully/lib/writefully/tools/../../../scripts/initialize.sh /Users/zacksiri/Repositories/writefully/spec/dummy/content #{message[:site_slug]} #{message[:ssh_url]}" }

      it "should have the correct command" do 
        initializer = Initializer.new(message)
        initializer.content_folder_setup_command.should eq command
        initializer.terminate
      end
    end
  end
end