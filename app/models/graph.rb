#coding: utf-8
# Graph Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# グラフモデル
# == テーブル作成
# rails generate model graph name:string title:string graph_type:integer term:integer
#                             x:string y:string y_max:integer y_min:integer
#                             analysis_type:integer useval:interger linewidth:integer template:string
# == 注意
# nameはTreasureData用データモデルのテーブル名とそろえる
# == サンプルグラフ
# rails c
# Graph.create(:name=>"test1",:title=>"newsite",:analysis_type=>0,:graph_type=>0,:term=>2,:x=>"time",:y=>"count",:useval=>0,:linewidth=>4,:template=>"white-dimgray",:y_max=>1000,:y_min=>0)
class Graph < ActiveRecord::Base
  # アソシエーション
  has_many :groupgraph
end
