json.array! @storages do |storage|
  json.partial! 'storage', storage: storage
end
