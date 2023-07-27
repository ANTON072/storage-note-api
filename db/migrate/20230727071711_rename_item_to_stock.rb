class RenameItemToStock < ActiveRecord::Migration[7.0]
  def change
    rename_table :items, :stocks
  end
end
