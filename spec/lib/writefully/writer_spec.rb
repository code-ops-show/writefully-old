require 'spec_helper'

describe Writefully::Writer do 
  fixtures :"writefully/posts"

  let(:index) { { resource: 'posts', slug: '2-rails-flash-partials' } }
  let(:cover_url) { 'https://codemycasts.s3.amazonaws.com/posts/2-rails-flash-partials/assets/cover.png' }

  subject(:writer) { Writefully::Writer.new(index) }

  its(:get_cover_url)         { should eq cover_url }
  its(:converted_body_assets) { should include cover_url }

  describe "changes to models" do 
    it "should create 1 new post" do 
      expect { 
        subject.write_content
      }.to change(Writefully::Post, :count).by(1)
    end

    it "should create 2 new tag" do 
      expect {  
        subject.write_content
      }.to change(Writefully::Tag, :count).by(2)
    end
  end

  describe "when post exists it should update" do 
    let(:index) { { resource: 'posts', slug: '1-hash-selector-pattern' } }

    it "should not create a new record" do 
      expect { 
        subject.write_content
      }.to change(Writefully::Post, :count).by(0)
    end
  end 
end