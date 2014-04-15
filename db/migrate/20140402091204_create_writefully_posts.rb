class CreateWritefullyPosts < ActiveRecord::Migration
  def change
    create_table :writefully_posts do |t|
      t.string     :title
      t.string     :slug
      t.string     :type
      t.text       :content
      t.hstore     :details
      t.datetime   :published_at
      t.integer    :position
      t.string     :locale, default: 'en'
      t.integer    :translation_source_id
      t.references :site,       index: true
      t.references :authorship, index: true

      t.timestamps
    end
    
    add_index :writefully_posts, :slug, unique: true
    add_index :writefully_posts, :translation_source_id
  end
end
