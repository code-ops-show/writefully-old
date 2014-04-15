class CreateWritefullySites < ActiveRecord::Migration
  def change
    create_table :writefully_sites do |t|
      t.string   :name
      t.string   :branch, default: 'master'
      t.string   :slug
      t.hstore   :repository
      t.string   :domain
      t.boolean  :processing, default: true
      t.boolean  :healthy,    default: false
      t.integer  :owner_id

      t.timestamps
    end
    
    add_index :writefully_sites, :slug, unique: true
    add_index :writefully_sites, :repository, using: :gin
    add_index :writefully_sites, :owner_id
  end
end
