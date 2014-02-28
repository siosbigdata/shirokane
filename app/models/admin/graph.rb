#coding: utf-8
# Admin::Graph Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# 管理用グラフモデル
class Admin::Graph < Graph
  TYPE = ['line', 'bar', 'pie']
  H_YESNO = { 0 => 'no', 1 => 'yes' }
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
        tdtable = Tdtable.graph_data(graph, end: oldday_s, start: today_s)

        # グラフ表示用データ作成
        if tdtable
          res_graph_data = set_graph_data(tdtable, graph.term, oldday, today, res_graph_terms['stime'])

          dashboard_settings["template"] << template
          dashboard_settings["xdatas"]  << res_graph_data['xdata']
          dashboard_settings["ydatas"]  << res_graph_data['ydata']
          dashboard_settings["terms"] << res_graph_terms['term_s']
        end
      end

      p dashboard_settings["template"][0]
      return dashboard_settings
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
        term_s = oldday.month.to_s + I18n.t("datetime.prompts.month") + oldday.day.to_s + I18n.t("datetime.prompts.day") + " - " + today.month.to_s + I18n.t("datetime.prompts.month") + today.day.to_s + t("datetime.prompts.day")
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

