#coding: utf-8
# Admin::Groupgraph Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# 管理用グループグラフモデル
# == テーブル作成
# rails generate model groupgraph group_id:integer graph_id:integer
class Admin::Groupgraph < ActiveRecord::Base
  #テーブル名の指定
  self.table_name = 'groupgraphs'

end
