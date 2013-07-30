#coding: utf-8
# Admin::Groupgraph Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

class Admin::Groupgraph < ActiveRecord::Base
  #テーブル名の指定
    self.table_name = 'groupgraphs'
    
  #belongs_to :graph
end
