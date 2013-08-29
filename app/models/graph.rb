#coding: utf-8
# Graph Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# グラフモデル
# == テーブル作成
# rails generate model graph name:string title:string graph_type:integer term:integer y:string analysis_type:integer useval:interger linewidth:integer template:string
# == 注意
# nameはTreasureData用データモデルのテーブル名とそろえる
class Graph < ActiveRecord::Base
  # アソシエーション
  has_many :groupgraph
end
