class CreateStorages < ActiveRecord::Migration[7.0]
  def change
    create_table :storages do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :description
      t.string :image_url

      t.timestamps
    end

    add_index :storages, :slug, unique: true
  end
end
