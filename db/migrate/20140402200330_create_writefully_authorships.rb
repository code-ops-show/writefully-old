class CreateWritefullyAuthorships < ActiveRecord::Migration
  def change
    create_table :writefully_authorships do |t|
      t.references :user, index: true
      t.hstore     :data
      t.string     :role

      t.timestamps
    end
  end
end
