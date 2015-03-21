require 'spec_helper'
require 'celluloid'
require 'writefully/tools'

module Writefully
  module Tools
    describe Pencil do 
      fixtures :"writefully/sites"
      fixtures :"writefully/posts"

      let(:index)   { {site: 'codemy-net', resource: 'posts', slug: '1-hash-selector-pattern' } }
      let(:index_2)   { {site: 'codemy-net', resource: 'posts', slug: '2-rails-flash-partials' } }
      let(:computed_attributes) { 
        { 
          "title" => "Ruby Hash Selector Pattern",
          "tags" => ["Ruby"],
          "playlists" => ["A Shot of Ruby"],
          "position" => 1,
          "content" => "converted stuff",
          "details" => "converted stuff",
          "trashed" => false
        }
      }

      before do 
        $stdout.stub(:write)
        $stderr.stub(:write)
        Asset.any_instance.stub(:convert_for).and_return("converted stuff")
      end

      it "#computed_attributes" do 
        pencil = Pencil.new(index)
        expect(pencil.computed_attributes).to eq computed_attributes 
        pencil.terminate
      end

      describe "#write" do 
        it "should create new post" do 
          pencil = Pencil.new(index)
          expect { 
            pencil.write
          }.to change(Post, :count).by(0)
          pencil.terminate
        end

        it "should update existing post" do 
          pencil = Pencil.new(index_2)
          expect { 
            pencil.write
          }.to change(Post, :count).by(1)
          pencil.terminate
        end
      end

      describe "#can_update_db" do
        it "can update" do 
          pencil = Pencil.new(index) 
          expect(pencil.can_update_db?([true, true])).to be true
          pencil.terminate
        end

        it "can't update" do 
          pencil = Pencil.new(index) 
          expect { 
            pencil.can_update_db?([true])
          }.to raise_error Writefully::Tools::Pencil::SomeAssetsNotUploaded
        end
      end

    end
  end
end