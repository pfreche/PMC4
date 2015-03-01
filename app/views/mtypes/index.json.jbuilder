json.array!(@mtypes) do |mtype|
  json.extract! mtype, :id, :name, :icon, :model, :has_file
  json.url mtype_url(mtype, format: :json)
end
