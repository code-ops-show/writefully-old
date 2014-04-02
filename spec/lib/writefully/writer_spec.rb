require 'spec_helper'

describe Writefully::Writer do 
  let(:index) { { resource: 'posts', slug: '2-rails-flash-partials' } }
  let(:cover_url) { 'https://codemycasts.s3.amazonaws.com/posts/2-rails-flash-partials/assets/cover.png' }

  subject(:writer) { Writefully::Writer.new(index) }

  its(:get_cover_url) { should eq cover_url }
end