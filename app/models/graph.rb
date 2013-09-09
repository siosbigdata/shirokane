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
# == 注意
# nameはTreasureData用データモデルのテーブル名とそろえる
# == サンプルグラフ
# rails c
# Graph.create(:name=>"newgraph",:title=>"newgraph",:analysis_type=>0,:graph_type=>0,:term=>2
#  ,:y=>"count",:y_min=>0,:y_max_time=>100,:y_max_day=>1000,:y_max_month=>1000
#  ,:useval=>0,:useshadow=>0,:usetip => 0,:linewidth=>2,:template=>"white-dimgray"
#  ,:usepredata:integer=>0,:uselastyeardata:integer=>0)
class Graph < ActiveRecord::Base
  # アソシエーション
  has_many :groupgraph
end
