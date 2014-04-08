class CreateWritefullySites < ActiveRecord::Migration
  def change
    create_table :writefully_sites do |t|
      t.string   :name
      t.string   :access_token
      t.string   :branch, default: 'master'
      t.hstore   :repository
      t.string   :domain
      t.boolean  :processing
      t.integer  :owner_id

      t.timestamps
    end

    add_index :writefully_sites, :repository, using: :gin
    add_index :writefully_sites, :owner_id
  end
end
