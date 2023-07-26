json.array! @categories.each do |category|
  json.extract! category, :id, :name, :created_at
end
