json.array!(@admin_groups) do |admin_group|
  json.extract! admin_group, :name, :title
  json.url admin_group_url(admin_group, format: :json)
end
