class User < ActiveRecord::Base
  has_secure_password
  #グループ一覧用
  belongs_to :group
end
