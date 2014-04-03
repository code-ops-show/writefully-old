class CreateWritefullyPosts < ActiveRecord::Migration
  def change
    create_table :writefully_posts do |t|
      t.string     :title
      t.string     :slug
      t.text       :content
      t.string     :type
      t.integer    :position
      t.datetime   :published_at
      t.references :authorship, index: true
      t.hstore     :details

      t.timestamps
    end
    
    add_index :writefully_posts, :slug, unique: true
  end
end
