json.array!(@folders) do |folder|
  json.extract! folder, :storage_id, :mpath, :lfolder, :mfile_id
  json.url folder_url(folder, format: :json)
end
