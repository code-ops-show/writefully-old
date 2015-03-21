require 'spec_helper'

module Writefully
  describe Taxon do 
    subject(:taxon) { Taxon.new(["Ruby", "Functional"], ["Ruby"], "Writefully::Tag")}

    it "#non_existing" do 
      subject.non_existing.first.name.should eq "Functional"
    end

    its(:selector) { should eq :"writefully/tag" }
    its(:type_attribute) { should eq ({ type: nil }) }

    describe "when type is 'playlist'" do 
      subject(:taxon) { Taxon.new(["Beginning Ruby", "Beginner"], ["Beginner"], "Playlist") }
      let(:attributes)  { {name: "Beginning Ruby", slug: 'beginning-ruby', type: 'Playlist' } }

      its(:selector) { should eq :playlist }
      its(:type_attribute) { should eq ({type: "Playlist"}) }

      it "#build_attributes" do 
        built_attributes = subject.build_attributes("Beginning Ruby")
        expect(built_attributes).to eq attributes
      end
    end
  end
end