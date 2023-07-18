json.array! @storages do |storage|
  members = @members.select { |m| m.storage_id == storage.id }.map do |m|
    { name: m.name, photo_url: m.photo_url }
  end
  json.id storage.slug
  json.name storage.name
  json.description storage.description
  json.image_url storage.image_url
  json.members members
end
