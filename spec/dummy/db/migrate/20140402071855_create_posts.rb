class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string  :name
      t.string  :slug
      t.text    :content
      t.string  :description
      t.string  :video
      t.boolean :free
      t.

      t.timestamps
    end
  end
end
