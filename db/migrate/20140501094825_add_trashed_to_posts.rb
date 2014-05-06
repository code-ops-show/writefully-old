class AddTrashedToPosts < ActiveRecord::Migration
  def change
    add_column :writefully_posts, :trashed, :boolean, default: false
  end
end
