#coding: utf-8
# Graph Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# グラフモデル
# == テーブル作成
# rails generate model graph name:string title:string graph_type:integer term:integer
#                             y:string y_max:integer y_min:integer
#                             analysis_type:integer useval:interger useshadow:integer
#                             linewidth:integer template:string
# == 注意
# nameはTreasureData用データモデルのテーブル名とそろえる
# == サンプルグラフ
# rails c
# Graph.create(:name=>"test1",:title=>"newsite",:analysis_type=>0,:graph_type=>0,:term=>2,:y=>"count",:y_max=>1000,:y_min=>0,:useval=>0,:useshadow=>0,:linewidth=>2,:template=>"white-dimgray")
class Graph < ActiveRecord::Base
  # アソシエーション
  has_many :groupgraph
end
