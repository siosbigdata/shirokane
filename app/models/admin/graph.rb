#coding: utf-8
# Admin::Graph Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# 管理用グラフモデル
# == テーブル作成
# rails generate model graph name:string title:string graph_type:integer term:integer x:string y:string analysis_type:integer useval:interger linewidth:integer template:string
# == 注意
# nameはTreasureData用データモデルのテーブル名とそろえる
class Admin::Graph < ActiveRecord::Base
  #テーブル名の指定
  self.table_name = 'graphs'
  
  #入力チェック
  validates :name,   :presence => true,:uniqueness=>true        # 名前
  validates :title,  :presence => true                          # 表示名
  validates :analysis_type,  :presence => true                  # 分析タイプ（集計、平均）
  validates :graph_type,  :presence => true                     # グラフタイプ（折線、縦棒）
  validates :term,  :presence => true                           # 期間
  validates :x,  :presence => true                              # x
  validates :y,  :presence => true                              # y
  validates :useval, :presence => true,:numericality => true    # グラフに値を表示するかどうか
  validates :linewidth, :presence => true,:numericality => true # 線の太さ
  validates :template, :presence => true                        # テンプレート名
  
  # アソシエーション
  has_many :groupgraph
end

