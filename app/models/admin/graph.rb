#coding: utf-8
# Admin::Graph Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# 管理用グラフテーブル
class Admin::Graph < ActiveRecord::Base
  #テーブル名の指定
  self.table_name = 'graphs'
  
  #入力チェック
  validates :name,   :presence => true,:uniqueness=>true        # 名前
  validates :title,  :presence => true                          # 表示名
  validates :analysis_type,  :presence => true                  # 分析タイプ（集計、平均）
  validates :graph_type,  :presence => true                     # グラフタイプ（折線、縦棒）
  validates :term,  :presence => true                           # 期間
  validates :x,  :presence => true
  validates :y,  :presence => true
  validates :useval, :presence => true,:numericality => true
  validates :linewidth, :presence => true,:numericality => true
  validates :template, :presence => true
  
  # アソシエーション
  has_many :groupgraph
end
