members = @members.select { |m| m.storage_id == storage.id }
                  .map { |m| { name: m.name, photo_url: m.name, is_owner: m.role == 1 } }
                  .sort_by { |m| m[:is_owner] ? 0 : 1 }

json.id storage.slug
json.name storage.name
json.description storage.description || ''
json.image_url storage.image_url || ''
json.members members || []
