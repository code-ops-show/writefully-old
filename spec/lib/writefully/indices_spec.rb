require 'spec_helper'

module Writefully
  describe Indices do 
    let(:full_path) { ['/Users/zacksiri/Repositories/writefully/spec/dummy/content/posts/1-hash-selector-pattern/README.md'] }
    let(:index)     { [{resource: 'posts', slug: '1-hash-selector-pattern' }] }
    subject { Indices }

    before do 
      Writefully.stub(:options).and_return({content: '/Users/zacksiri/Repositories/writefully/spec/dummy/content/' })
    end

    it "#build_from" do  
      Indices.build_from(full_path).should eq index 
    end
  end 
end