require 'spec_helper'

describe Writefully::Writer do 
  let(:index) { { resource: 'posts', slug: '2-rails-flash-partials' } }
  let(:cover_url) { 'https://codemycasts.s3.amazonaws.com/posts/2-rails-flash-partials/assets/cover.png' }

  subject(:writer) { Writefully::Writer.new(index) }

  its(:get_cover_url)         { should eq cover_url }
  its(:converted_body_assets) { should include cover_url }

  it "should create 1 new post" do 
    expect { 
      subject.write_content
    }.to change(Writefully::Post, :count).by(1)
  end
end