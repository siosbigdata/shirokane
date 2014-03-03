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

  validates :title, :presence => true                           # 表示名
  validates :analysis_type,  :presence => true                  # 分析タイプ（集計、平均）
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
  
  class << self
    def set_setting
      dashboard_settings = {
        "template" => [],
        "xdatas"   => [],
        "ydatas"   => [],
        "terms"    => [],
      }
      all.each do |graph|
        # 指定テンプレート情報
        template = Graphtemplate.find_by_name(graph.template)
  
        #期間移動分
        today = Date.today
  
        # 期間の設定
        res_graph_terms = set_graph_term(graph.term, today, 0)
        today = res_graph_terms['today']
        oldday = res_graph_terms['oldday']
        # データ取得期間の設定
        today_s = today.to_s + " 23:59:59"
        oldday_s = oldday.to_s + " 00:00:00"
  
        # データの取得
        tdtable = Tdtable.graph_data(graph,term: graph.term, end: oldday_s, start: today_s)
  
        # グラフ表示用データ作成
        if tdtable
          res_graph_data = set_graph_data(tdtable, graph.term, oldday, today, res_graph_terms['stime'])
  
          dashboard_settings["template"] << template
          dashboard_settings["xdatas"]  << res_graph_data['xdata']
          dashboard_settings["ydatas"]  << res_graph_data['ydata']
          dashboard_settings["terms"] << res_graph_terms['term_s']
        end
      end

      return dashboard_settings
    end
  end
end

