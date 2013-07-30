#coding: utf-8
# Admin::Graph Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

class Admin::Graph < ActiveRecord::Base
  #テーブル名の指定
  self.table_name = 'graphs'
  #入力チェック
  validates :name,  :presence => true,:uniqueness=>true
  validates :title,  :presence => true
  
  has_many :groupgraph
end
