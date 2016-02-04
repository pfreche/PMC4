json.array!(@matches) do |match|
  json.extract! match, :id, :pattern, :extract, :tag, :filter
  json.url match_url(match, format: :json)
end
