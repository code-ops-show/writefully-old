require 'spec_helper'
require 'celluloid'
require 'writefully/tools'

module Writefully
  module Tools
    describe Initializer do 
      let(:message) { { user_name: "zacksiri", auth_token: 'sampletoken', site_slug: 'codemy-net', ssh_url: 'blah@blah.com:zacksiri/blah.git' } }

      it "should have the correct command" do 
        initializer = Initializer.new(message)
        initializer.content_folder_setup_command.should include message[:site_slug]
        initializer.content_folder_setup_command.should include message[:ssh_url]
      end
    end
  end
end