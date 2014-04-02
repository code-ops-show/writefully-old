class CreateWritefullyTaggings < ActiveRecord::Migration
  def change
    create_table :writefully_taggings do |t|
      t.references :tag, index: true
      t.references :post, index: true

      t.timestamps
    end
  end
end
