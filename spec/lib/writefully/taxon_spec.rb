require 'spec_helper'

module Writefully
  describe Taxon do 
    subject(:taxon) { Taxon.new(["Ruby", "Functional"], ["Ruby"], "Writefully::Tag")}

    it "#non_existing" do 
      expect(subject.non_existing.first.name).to eq "Functional"
    end

    its(:selector) { is_expected.to eq :"writefully/tag" }
    its(:type_attribute) { is_expected.to eq ({ type: nil }) }

    describe "when type is 'playlist'" do 
      subject(:taxon) { Taxon.new(["Beginning Ruby", "Beginner"], ["Beginner"], "Playlist") }
      let(:attributes)  { {name: "Beginning Ruby", slug: 'beginning-ruby', type: 'Playlist' } }

      its(:selector) { is_expected.to eq :playlist }
      its(:type_attribute) { is_expected.to eq ({type: "Playlist"}) }

      it "#build_attributes" do 
        built_attributes = subject.build_attributes("Beginning Ruby")
        expect(built_attributes).to eq attributes
      end
    end
  end
end