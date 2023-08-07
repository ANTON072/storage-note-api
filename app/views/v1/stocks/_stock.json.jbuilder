json.extract! stock, :id, :name, :item_count, :item_count, :image_url, :description, :price,
              :unit_name, :purchase_location, :alert_threshold, :is_favorite, :category_id, :created_at, :updated_at
if stock.created_by
  json.created_by do
    json.extract! stock.created_by, :name, :photo_url
  end
else
  # ユーザーが退会した場合nilになる
  json.created_by nil
end
if stock.updated_by
  json.updated_by do
    json.extract! stock.updated_by, :name, :photo_url
  end
else
  # ユーザーが退会した場合nilになる
  json.updated_by nil
end
