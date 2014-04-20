require 'spec_helper'
require 'celluloid'
require 'writefully/tools'

module Writefully
  module Tools
    describe Synchronizer do 
      let(:message) { { site_slug: 'codemy-net' } }

      it "should have the correct command" do 
        sync = Synchronizer.new(message)
        sync.sync_command.should include message[:site_slug]
        sync.terminate
      end
    end
  end
end