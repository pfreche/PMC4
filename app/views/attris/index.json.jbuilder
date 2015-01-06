json.array!(@attris) do |attri|
  json.extract! attri, :name, :agroup_id, :id_sort, :parent_id, :keycode
  json.url attri_url(attri, format: :json)
end
