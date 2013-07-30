#coding: utf-8
# Admin::Setting Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.30

# 管理用パラメーターテーブル
class Admin::Setting < ActiveRecord::Base
  #テーブル名の指定
    self.table_name = 'settings'
end
