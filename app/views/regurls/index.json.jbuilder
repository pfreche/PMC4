json.array!(@regurls) do |regurl|
  json.extract! regurl, :id, :pattern, :extract, :examURL, :fin
  json.url regurl_url(regurl, format: :json)
end
