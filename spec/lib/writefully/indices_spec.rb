require 'spec_helper'

module Writefully
  describe Indices do 
    let(:full_path) { ['/Users/zacksiri/Repositories/writefully/spec/dummy/content/codemy-net/posts/1-hash-selector-pattern/README.md'] }
    let(:index)     { [{site: 'codemy-net', resource: 'posts', slug: '1-hash-selector-pattern' }] }
    subject { Indices }

    before do 
      Writefully.stub(:options).and_return({content: '/Users/zacksiri/Repositories/writefully/spec/dummy/content/' })
    end

    it "#build_from" do  
      expect(Indices.build_from(full_path)).to eq index 
    end
  end 
end