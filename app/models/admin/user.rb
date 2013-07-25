class Admin::User < ActiveRecord::Base
  self.table_name = 'users'
  #attr_accessible :name, :password_digest, :password, :password_confirmation
  has_secure_password
  belongs_to :group
end
