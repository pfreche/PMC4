json.array!(@agroups) do |agroup|
  json.extract! agroup, :name
  json.url agroup_url(agroup, format: :json)
end
