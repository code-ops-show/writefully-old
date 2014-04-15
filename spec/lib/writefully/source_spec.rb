require 'spec_helper'

module Writefully
  describe Source do 
    subject(:source) { Writefully::Source }
    let(:indices)    { [{site: 'codemy-net', resource: 'posts', slug: '1-hash-selector-pattern'}, 
                        {site: 'codemy-net', resource: 'posts', slug: '2-rails-flash-partials'} ]}

    its(:to_load)     { should =~ ['post', 'playlist'] }
  end
end