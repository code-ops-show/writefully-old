require 'spec_helper'

describe Writefully::Content do 
  let(:index) { {resource: 'posts', slug: '1-hash-selector-pattern' } }
  let(:meta)  { { 
    "title"        => "Ruby Hash Selector Pattern",
    "slug"        => "ruby-hash-selector-pattern",
    "tags"        => ["Ruby"],
    "playlists"   => ["A Shot of Ruby"],
    "details"     => { "blurb" => "We show you an alternative to if / else and case / switch.",
                       "cover" => "assets/hash-selector-icon.png" },
    "position"    => 1
  } }
  subject(:content) { Writefully::Content.new(index) }

  its(:body)     { should include "# Hash Selector Pattern" }
  its(:meta)     { should eq meta }
  its(:slug)     { should eq 'ruby-hash-selector-pattern' }
  its(:position) { should eq 1 }
end