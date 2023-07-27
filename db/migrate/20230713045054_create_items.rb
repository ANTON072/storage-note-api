class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.references :storage, null: false, foreign_key: true
      t.string :name, null: false
      t.string :description
      t.string :image_url
      t.references :category, foreign_key: true
      t.integer :item_count, null: false
      t.references :updated_by, foreign_key: { to_table: :users }
      t.references :created_by, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :items, :name
  end
end
