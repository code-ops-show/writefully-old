class CreateWritefullyPosts < ActiveRecord::Migration
  def change
    create_table :writefully_posts do |t|
      t.string :title
      t.string :blurb
      t.text   :content
      t.string :type
      t.string :slug
      t.string :cover
      t.integer :position
      t.datetime :published_at

      t.timestamps
    end
    
    add_index :writefully_posts, :slug, unique: true
  end
end
