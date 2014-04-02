require 'spec_helper'

describe Writefully::Source do 
  subject(:source) { Writefully::Source }
  let(:indices)    { [{resource: 'posts', slug: '1-hash-selector-pattern'}, 
                      {resource: 'posts', slug: '2-rails-flash-partials'} ]}

  its(:available)   { should include 'post' } 
  its(:valid)       { should include 'post' }
  its(:indices)     { should =~ indices }
  its(:contentable) { should eq ['posts']}
end