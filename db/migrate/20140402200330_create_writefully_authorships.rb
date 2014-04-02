class CreateWritefullyAuthorships < ActiveRecord::Migration
  def change
    create_table :writefully_authorships do |t|
      t.string :bio
      t.references :user, index: true

      t.timestamps
    end
  end
end
