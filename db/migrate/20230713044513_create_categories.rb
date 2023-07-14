class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.references :storage, null: false, foreign_key: true

      t.timestamps
    end

    add_index :categories, %i[storage_id name], unique: true
  end
end
