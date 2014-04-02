require 'spec_helper'

describe Writefully::Content do 
  let(:index) { {resource: 'posts', slug: '1-hash-selector-pattern' } }
  let(:meta)  { { 
    "name"        => "Ruby Hash Selector Pattern",
    "slug"        => "ruby-hash-selector-pattern",
    "cover"       => "hash-selector-icon.png",
    "description" => "We show you an alternative to if / else and case / switch.",
    "video"       => "http://www.youtube.com/watch?v=Pyg-31Nhd8I",
    "tags"        => ["Ruby"],
    "free"        => true,
    "position"    => 1
  } }
  subject(:content) { Writefully::Content.new(index) }

  its(:body)     { should include "# Hash Selector Pattern" }
  its(:meta)     { should eq meta }
  its(:slug)     { should eq 'ruby-hash-selector-pattern' }
  its(:position) { should eq 1 }
end