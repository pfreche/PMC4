json.array!(@mfiles) do |mfile|
  json.extract! mfile, :folder_id, :filename, :modified, :mod_date
  json.url mfile_url(mfile, format: :json)
end
