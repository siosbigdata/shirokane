#coding: utf-8
# Admin::Setting Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.30

# 管理用パラメーターテーブル
class Admin::Setting < Setting
  # 入力チェック
  validates :parameter,  :presence => true
end
