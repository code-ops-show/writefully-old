class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.string     :taggable_type
      t.integer    :taggable_id

      t.references :tag

      t.timestamps
    end

    add_index :taggings, [:taggable_type, :taggable_id]
  end
end
