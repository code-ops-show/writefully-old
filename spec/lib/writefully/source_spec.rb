require 'spec_helper'

module Writefully
  describe Source do 
    subject(:source) { Writefully::Source }
    let(:indices)    { [{site: 'codemy-net', resource: 'posts', slug: '1-hash-selector-pattern'}, 
                        {site: 'codemy-net', resource: 'posts', slug: '2-rails-flash-partials'} ]}

    its(:to_load)         { should =~ ['post', 'playlist'] }
    its(:valid_resources) { should =~ ['posts'] }

    it "should open README" do 
      subject.sample_content("README").read.should include "# Welcome to Writefully!"
    end
  end
end