class Admin::User < ActiveRecord::Base
  self.table_name = 'users'
  has_secure_password
end
