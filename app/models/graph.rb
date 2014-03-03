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
  
  # 定数
  DAY = 0
  WEEK = 1
  MONTH = 2
  YEAR = 3
  TYPE = ['line', 'bar', 'pie']
  YESNO = { 0 => 'no', 1 => 'yes' }
  SETTINGS = {
    :h_analysis_types => {
      0 => I18n.t('analysis_types_sum'),
      1 => I18n.t('analysis_types_avg'),
    },
    :h_graph_types => {
      0 => I18n.t('graph_types_line'),
      1 => I18n.t('graph_types_bar'),
    },
    :h_terms => {
      0 => I18n.t('datetime.prompts.day'),
      1 => I18n.t('week'),
      2 => I18n.t('datetime.prompts.month'),
      3 => I18n.t('datetime.prompts.year'),
    },
    :h_yesno => {
      0 => I18n.t('title_no'),
      1 => I18n.t('title_yes'),
    },
  }

  class << self
    def set_setting group_id
      p "★★★Graph::set_setting★★★★★★★★★★★★"
      dashboard_settings = {
        "graphs" => [],
        "template" => [],
        "xdatas"   => [],
        "ydatas"   => [],
        "terms"    => [],
      }

      dashboardgraphs = Groupgraph.where(:group_id=>group_id,:dashboard => true).order(:view_rank)
      
      dashboardgraphs.each do |groupgraphs|
        # グラフの取得
        graph = Graph.find(groupgraphs.graph_id)

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
        tdtable = Tdtable.graph_data(graph, term: graph.term, end: oldday_s, start: today_s)
  
        # グラフ表示用データ作成
        if tdtable
          res_graph_data = set_graph_data(tdtable, graph.term, oldday, today, res_graph_terms['stime'])
  
          dashboard_settings["graphs"] << graph
          dashboard_settings["template"] << template
          dashboard_settings["xdatas"]  << res_graph_data['xdata']
          dashboard_settings["ydatas"]  << res_graph_data['ydata']
          dashboard_settings["terms"] << res_graph_terms['term_s']
        end
      end
      return dashboard_settings
    end

    # グラフのマージ機能を利用させるかどうか
    def get_use_merge_graph
      res = false
      if $settings['use_merge_graph'] 
        if $settings['use_merge_graph'].to_i == 1
          res = true
        end
      end
      return res
    end
    
    # グラフの新規追加機能を利用させるかどうか
    def get_use_create_graph
      res = false
      if $settings['use_create_graph'] 
        if $settings['use_create_graph'].to_i == 1
          res = true
        end
      end
      return res
    end

    # グラフ表示期間の設定
    def set_graph_term(graph_term,today,addcnt)
      case graph_term
      when 0 # 日の時間別のデータを表示する
        today = today + addcnt.to_i.days # 追加日数
        oldday = today
        term_s = today.month.to_s + I18n.t("datetime.prompts.month") + today.day.to_s + I18n.t("datetime.prompts.day")
        graphx = I18n.t("datetime.prompts.hour")
        stime = "%H"
      when 1  # 週:７日分の日別データを表示する
        today = today + (addcnt.to_i * 7).days # 追加日数
        # 月曜日から開始するように調整
        today = today + (7-today.wday).days
        oldday = today - 6.days
        term_s = oldday.month.to_s + I18n.t("datetime.prompts.month") 
        term_s <<  oldday.day.to_s + I18n.t("datetime.prompts.day") + " - " 
        term_s <<  today.month.to_s + I18n.t("datetime.prompts.month") 
        term_s <<  today.day.to_s + I18n.t("datetime.prompts.day")
        graphx = I18n.t("datetime.prompts.day")
        stime = "%d"
      when 2  # 月:１ヶ月分のデータを表示する
        today = today + addcnt.to_i.months # 追加日数
        # 月初から開始するように調整
        nowmonth = Date::new(today.year,today.month, 1)
        today = nowmonth >> 1
        today = today - 1.day
        oldday = nowmonth
        term_s = oldday.year.to_s + I18n.t("datetime.prompts.year") + oldday.month.to_s + I18n.t("datetime.prompts.month")
        graphx = I18n.t("datetime.prompts.day")
        stime = "%d"
      when 3  # 年:１ヶ月ごとのデータを表示する。
        today = today + addcnt.to_i.years # 追加日数
        # 年初から開始するように調整
        nowyear = Date::new(today.year,1, 1)
        today = nowyear + 1.year - 1.day
        oldday = nowyear
        term_s = oldday.year.to_s + I18n.t("datetime.prompts.year")
        graphx = I18n.t("datetime.prompts.month")
        stime = "%m"
      end
      # 戻り値準備
      res = Hash.new
      res['today'] = today
      res['oldday'] = oldday
      res['term_s'] = term_s
      res['graphx'] = graphx
      res['stime'] = stime
      return res
    end

    # グラフ表示用データ作成
    def set_graph_data(tdtable,graph_term,oldday,today,stime)
      xdata = ""
      ydata = ""

      weekflg = false
      # 開始日と終了日をチェック
      case graph_term
      when 0 # 日
        snum = 0
        enum = 23
      when 1 # 週
        snum = oldday.day.to_i
        enum = today.day.to_i
        if enum < snum  # 週間表示の場合で月をまたいでしまったときの処理
          weekflg = true # フラグをたてる
          snum2 = 1
          enum2 = enum
          nm = Date::new(today.year,today.month, 1)
          eday = nm - 1.day
          enum = eday.day.to_i
        end
      when 2 # 月
        snum = oldday.day.to_i
        enum = today.day.to_i
      when 3 # 年
        snum = 1
        enum = 12
      end

      # 値の設定
      for dd in snum .. enum
        xdata = xdata + "," + dd.to_s
        flg = true
        tdtable.each do |ddy|
          if ddy.td_time.strftime(stime.to_s).to_i == dd
            ydata = ydata + "," + ddy.td_count.to_i.to_s
            flg =false
            break
          end
        end
        if flg  # 値が存在しない場合は0を設定
          ydata = ydata + ",0"
        end
      end
      # 月をまたいでしまったときの特別処理
      if weekflg
        for dd in snum2 .. enum2
          xdata = xdata + "," + dd.to_s
          flg = true
          tdtable.each do |ddy|
            if ddy.td_time.strftime(stime).to_i == dd
              ydata = ydata + "," + ddy.td_count.to_i.to_s
              flg =false
              break
            end
          end
          if flg  # 値が存在しない場合は0を設定
            ydata = ydata + ",0"
          end
        end
      end
      # 戻り値の作成
      res = Hash.new
      res['xdata'] = xdata
      res['ydata'] = ydata
      return res
    end
  end
end
