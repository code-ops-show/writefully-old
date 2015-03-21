require 'spec_helper'

module Writefully
  describe Source do 
    subject(:source) { Writefully::Source }
    let(:indices)    { [{site: 'codemy-net', resource: 'posts', slug: '1-hash-selector-pattern'}, 
                        {site: 'codemy-net', resource: 'posts', slug: '2-rails-flash-partials'} ]}


    let(:sample_paths) { ['posts/1-change-me/README.md', 
                          'posts/1-change-me/meta.yml', 
                          'posts/1-change-me/assets/writefully.png' ] }

    its(:to_load)         { are_expected.to contain_exactly('post', 'playlist') }
    its(:valid_resources) { are_expected.to contain_exactly('posts') }

    it "should open README" do 
      expect(subject.sample_content("README.md")).to include "# Welcome to Writefully!"
    end

    its(:sample_content_paths) { are_expected.to eq sample_paths }
  end
end