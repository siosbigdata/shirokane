#coding: utf-8
# Graph Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# グラフモデル
# == 作成
# rails generate model graph name:string title:string graph_type:integer term:integer
#                             y:string  y_min:integer y_max_time:integer y_max_day:integer y_max_month:integer
#                             analysis_type:integer useval:interger useshadow:integer usetip:integer
#                             linewidth:integer template:string
#                             usepredata:integer uselastyeardata:integer
#                             y_unit:string 
#                             merge_linecolor:string merge_graph:string
# == 注意
# nameはTreasureData用データモデルのテーブル名とそろえる
class Graph < ActiveRecord::Base
  # アソシエーション
  has_many :groupgraph
end
