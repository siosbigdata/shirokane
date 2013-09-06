#coding: utf-8
# Admin::Graph Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# 管理用グラフモデル
class Admin::Graph < Graph
  #入力チェック
  validates :name,   :presence => true,:uniqueness=>true        # 名前
  validates :title,  :presence => true                          # 表示名
  validates :analysis_type,  :presence => true                  # 分析タイプ（集計、平均）
  validates :graph_type,  :presence => true                     # グラフタイプ（折線、縦棒）
  validates :term,  :presence => true                           # 期間
  validates :y,  :presence => true                              # y
  validates :y_min,  :presence => true                          # y最小値
  validates :y_max_time,  :presence => true                     # y最大値 時間
  validates :y_max_day,  :presence => true                      # y最大値 日
  validates :y_max_month,  :presence => true                    # y最大値 月
  validates :useval, :presence => true,:numericality => true    # グラフに値を表示するかどうか
  validates :useshadow, :presence => true,:numericality => true # グラフに影をつけるかどうか
  validates :usetip, :presence => true,:numericality => true    # グラフにチップをつけるかどうか
  validates :linewidth, :presence => true,:numericality => true # 線の太さ
  validates :template, :presence => true                        # テンプレート名
end

