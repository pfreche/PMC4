json.array!(@storages) do |storage|
  json.extract! storage, 
  json.url storage_url(storage, format: :json)
end
