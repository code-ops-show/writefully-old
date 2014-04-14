require 'spec_helper'
require 'celluloid'
require 'writefully/tools'

module Writefully
  module Tools
    describe Pencil do 
      let(:index)   { {resource: 'posts', slug: '1-hash-selector-pattern' } }
      let(:site_id) { 1 }
      let(:computed_attributes) { 
        { 
          "title" => "Ruby Hash Selector Pattern",
          "slug" => "ruby-hash-selector-pattern",
          "tags" => ["Ruby"],
          "playlists" => ["A Shot of Ruby"],
          "position" => 1,
          "content" => "converted stuff",
          "details" => "converted stuff"
        }
      }

      before do 
        $stdout.stub(:write)
        $stderr.stub(:write)
        Asset.any_instance.stub(:convert_for).and_return("converted stuff")
      end

      it "#computed_attributes" do 
        pencil = Pencil.new(index, site_id)
        pencil.computed_attributes.should eq computed_attributes 
        pencil.terminate
      end

      describe "#can_update_db" do
        it "can update" do 
          pencil = Pencil.new(index, site_id) 
          pencil.can_update_db?([true, true]).should be_true
          pencil.terminate
        end

        it "can't update" do 
          pencil = Pencil.new(index, site_id) 
          expect { 
            pencil.can_update_db?([true])
          }.to raise_error Writefully::Tools::Pencil::SomeAssetsNotUploaded
        end
      end

    end
  end
end