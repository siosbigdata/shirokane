json.array!(@admin_users) do |admin_user|
  json.extract! admin_user, :name, :password_digest, :title, :mail, :group, :admin
  json.url admin_user_url(admin_user, format: :json)
end
