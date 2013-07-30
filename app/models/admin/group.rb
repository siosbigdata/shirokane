#coding: utf-8
# Admin::Group Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# 管理用グループテーブル
class Admin::Group < ActiveRecord::Base
  # テーブル名
  self.table_name = 'groups'
  
  #入力チェック
  validates :name,  :presence => true,:uniqueness=>true
  validates :title,  :presence => true,:uniqueness=>true
end
