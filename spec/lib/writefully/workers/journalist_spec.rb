require 'spec_helper'
require 'celluloid'
require 'writefully/tools'
require 'writefully/workers'

module Writefully
  module Workers
    describe Journalist do 
      let(:index) { { resource: 'posts', slug: '1-hash-selector-pattern' } }
      let(:index_with_tries) { index.merge({tries: 2}) }
      let(:pencil) { double("Pencil", perform: true) }
      subject(:journalist) { Journalist.new }

      before do 
        Journalist.any_instance.stub(:index).and_return(index)
        Tools::Pencil.stub(:new_link).and_return(pencil)
      end


      its(:index_with_tries) { should eq index_with_tries }

      it "#publish_content" do 
        pencil.should_receive(:perform).once
        subject.publish_content(index)
      end

      after { subject.terminate }

    end
  end
end