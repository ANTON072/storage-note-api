class AddColumnsToStocks < ActiveRecord::Migration[7.0]
  def change
    add_column :stocks, :purchase_location, :string
    add_column :stocks, :price, :string
    add_column :stocks, :unit_name, :string
    add_column :stocks, :alert_threshold, :integer
    add_column :stocks, :is_favorite, :boolean
  end
end
