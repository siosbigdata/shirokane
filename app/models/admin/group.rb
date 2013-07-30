#coding: utf-8
# Admin::Group Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.25
class Admin::Group < ActiveRecord::Base
  self.table_name = 'groups'
  #グラフ一覧用
  #belongs_to :graph
  #入力チェック
  validates :name,  :presence => true,:uniqueness=>true
  validates :title,  :presence => true,:uniqueness=>true
end
