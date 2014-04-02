require 'spec_helper'

describe Writefully::Asset do 
  let(:index) { {resource: 'posts', slug: '1-hash-selector-pattern' } }
  subject(:asset) { Writefully::Asset.new(index) }

  its(:names) { should include 'hash-selector-cover.png' }
  its(:endpoint) { should eq 'posts/1-hash-selector-pattern/assets'}
end