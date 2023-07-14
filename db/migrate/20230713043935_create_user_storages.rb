class CreateUserStorages < ActiveRecord::Migration[7.0]
  def change
    create_table :user_storages do |t|
      t.references :user, null: false, foreign_key: true
      t.references :storage, null: false, foreign_key: true
      t.integer :role, null: false

      t.timestamps
    end
  end
end
