require 'spec_helper'

module Writefully
  describe Asset do 
    let(:index) { {site: 'codemy-net', resource: 'posts', slug: '1-hash-selector-pattern' } }
    subject(:asset) { Asset.new(index) }
    let(:url)   { "https://codemycasts.s3.amazonaws.com/posts/1-hash-selector-pattern/assets/" }

    let(:content_details) { Content.new(index).details }

    its(:names) { should include 'hash-selector-cover.png' }
    its(:endpoint) { should eq 'posts/1-hash-selector-pattern/assets'}

    it "#url" do 
      subject.url(Writefully::Storage.endpoint).should eq url
    end

    it "#convert_for" do 
      subject.convert_for(content_details)["cover"].should include url
    end
  end
end