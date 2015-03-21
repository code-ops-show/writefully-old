require 'spec_helper'

module Writefully
  describe Asset do 
    let(:index) { {site: 'codemy-net', resource: 'posts', slug: '1-hash-selector-pattern' } }
    subject(:asset) { Asset.new(index) }
    let(:url)   { "https://codemycasts.s3.amazonaws.com/codemy-net/posts/1-hash-selector-pattern/assets/" }

    let(:content_details) { Content.new(index).details }

    its(:names) { should include 'hash-selector-cover.png' }
    its(:endpoint) { should eq 'codemy-net/posts/1-hash-selector-pattern/assets'}

    it "#url" do 
      expect(subject.url(Writefully::Storage.endpoint)).to eq url
    end

    it "#convert_for" do 
      expect(subject.convert_for(content_details)["cover"]).to include url
    end
  end
end