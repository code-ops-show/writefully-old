require 'spec_helper'

module Writefully
  describe Source do 
    subject(:source) { Writefully::Source }
    let(:indices)    { [{resource: 'posts', slug: '1-hash-selector-pattern'}, 
                        {resource: 'posts', slug: '2-rails-flash-partials'} ]}

    its(:available)   { should include 'post' } 
    its(:valid)       { should include 'post' }
    its(:indices)     { should =~ indices }
    its(:contentable) { should eq ['posts'] }
    its(:to_load)     { should =~ ['post', 'playlist'] }
  end
end