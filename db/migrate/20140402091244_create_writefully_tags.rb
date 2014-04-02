class CreateWritefullyTags < ActiveRecord::Migration
  def change
    create_table :writefully_tags do |t|
      t.string :name
      t.string :slug
      t.string :type

      t.timestamps
    end

    add_index :writefully_tags, :slug, unique: true
  end
end
