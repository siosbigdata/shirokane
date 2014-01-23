#coding: utf-8
# Admin::Graph Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# 管理用グラフモデル
class Admin::Graph < Graph
  #入力チェック
  # 名前
  validates :name,
    :presence => true,
    :uniqueness=>true,
    :length=>{:maximum=>20},
    :format=>{:with => /^[a-zA-Z0-9]+$/,:multiline=>true,:message=> I18n.t('error_graph_name_format_message')},
      :Graphstable=>true
  
  # 表示名
  validates :title,
    :presence => true
  
  validates :analysis_type,  :presence => true                  
  validates :graph_type,  :presence => true                     # グラフタイプ（折線、縦棒）
  validates :term,  :presence => true                           # 期間
  validates :y,  :presence => true                              # y
  validates :y_min,  :presence => true,:numericality => true                          # y最小値
  validates :y_max_time,  :presence => true,:numericality => true                     # y最大値 時間
  validates :y_max_day,  :presence => true,:numericality => true                      # y最大値 日
  validates :y_max_month,  :presence => true,:numericality => true                    # y最大値 月
  validates :useval, :presence => true,:numericality => true    # グラフに値を表示するかどうか
  validates :useshadow, :presence => true,:numericality => true # グラフに影をつけるかどうか
  validates :usetip, :presence => true,:numericality => true    # グラフにチップをつけるかどうか
  validates :linewidth, :presence => true,:numericality => {:only_integer => true} # 線の太さ
  validates :template, :presence => true                        # テンプレート名
  validates :usepredata, :presence => true,:numericality => true    # 前日、前週、前月、前年のデータを表示するかどうか
  validates :uselastyeardata, :presence => true,:numericality => true    # １年前のデータを表示するかどうか
end

