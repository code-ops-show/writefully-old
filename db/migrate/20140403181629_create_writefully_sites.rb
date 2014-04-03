class CreateWritefullySites < ActiveRecord::Migration
  def change
    create_table :writefully_sites do |t|
      t.string :repository_id
      t.string :owner_uid
      t.string :hook_id
      t.string :last_processed_commit
      t.string :branch

      t.timestamps
    end
  end
end
