require 'spec_helper'

module Writefully
  describe Postable do 
    subject { ::Post.new } 

    describe "#klass_from" do 
      it "should return Writefully::Tag" do 
        expect(subject.klass_from("tag")).to eq "Writefully::Tag"
      end

      it "should turn Playlist" do 
        expect(subject.klass_from("playlist")).to eq "Playlist"
      end
    end

    it "should set published_at" do 
      subject.publish = true
      subject.publish_resource
      expect(subject.published_at).to_not be_nil
    end

    it "should taxonomize correctly" do 
      expect(subject.respond_to?(:playlists)).to be true
    end
  end
end