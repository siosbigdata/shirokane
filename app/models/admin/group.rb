#coding: utf-8
# Admin::Group Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# 管理用グループモデル
class Admin::Group < Group
  #入力チェック
  validates :name,  :presence => true,:uniqueness=>true
  validates :title,  :presence => true,:uniqueness=>true
  
  class << self
    def get_maxgroup
      return Admin::User.get_maxuser
    end
  end
end
