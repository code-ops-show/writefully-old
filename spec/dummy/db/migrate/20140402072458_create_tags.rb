class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.string :slug
      t.string :type

      t.timestamps
    end

    add_index :tags, :slug, unique: true
    add_index :tags, :type
  end
end
