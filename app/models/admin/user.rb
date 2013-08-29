#coding: utf-8
# Admin::User Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# 管理用ユーザモデル
class Admin::User < User
  #入力チェック
  validates :name,  :presence => true,:uniqueness=>true
end
