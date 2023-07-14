class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :firebase_uid, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.string :photo_url
      t.integer :state, null: false, default: 0

      t.timestamps
    end

    add_index :users, :firebase_uid, unique: true
    add_index :users, :name, unique: true
    add_index :users, :email, unique: true
  end
end
