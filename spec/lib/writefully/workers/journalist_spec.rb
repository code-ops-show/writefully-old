require 'spec_helper'
require 'celluloid'
require 'writefully/tools'
require 'writefully/workers'

module Writefully
  module Workers
    describe Journalist do 
      let(:message) { { resource: 'posts', slug: '1-hash-selector-pattern' } }
      let(:message_with_tries) { message.merge({tries: 2}) }
      let(:pencil) { double("Pencil", perform: true) }
      subject(:journalist) { Journalist.new }

      before do 
        Journalist.any_instance.stub(:message).and_return(message)
        Tools::Pencil.stub(:new_link).and_return(pencil)
      end

      its(:message_with_tries) { should eq message_with_tries }

      it "#publish" do 
        pencil.should_receive(:perform).once
        subject.publish
      end

      after { subject.terminate }

    end
  end
end