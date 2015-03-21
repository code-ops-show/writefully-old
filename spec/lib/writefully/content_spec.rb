require 'spec_helper'

module Writefully
  describe Content do 
    let(:index) { {site: 'codemy-net', resource: 'posts', slug: '1-hash-selector-pattern' } }
    let(:meta)  { { 
      "title"        => "Ruby Hash Selector Pattern",
      "tags"        => ["Ruby"],
      "playlists"   => ["A Shot of Ruby"],
      "details"     => { "blurb" => "We show you an alternative to if / else and case / switch.",
                         "cover" => "assets/hash-selector-icon.png" },
      "position"    => 1
    } }
    subject(:content) { Writefully::Content.new(index) }

    its(:body)     { is_expected.to include "# Hash Selector Pattern" }
    its(:meta)     { should eq meta }
    its(:slug)     { should eq 'hash-selector-pattern' }
    its(:position) { should eq 1 }
  end
end