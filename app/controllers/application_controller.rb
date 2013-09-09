#coding: utf-8
# ApplicationController
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# ApplicationController
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  protect_from_forgery

  # テーブル名取得
  def get_td_tablename(name)
    return "td_" + name
  end
  
# Settingsの値取得
  def get_settings
    if $settings == nil then
      ss = Setting.all
      $settings = Hash.new()
      ss.map{|s|
        $settings[s.name.to_s] = s.parameter.to_s
      }
    end
  end
  
  # グラフ用データの取得
  def td_graph_data(graph,term,startday,endday)
    # 表示テーブル名の設定
    Tdtable.table_name = get_td_tablename(graph.name)
    #SQLの作成
    if term == 1 || term == 2 then  # 週、月:日別データを表示する
      if graph.analysis_type == 1 then #集計タイプ : graph.analysis_type 0:集計、1:平均
        #平均
        tdtable = Tdtable.where(:td_time => startday .. endday).group("date_trunc('day',td_time)").select("date_trunc('day',td_time) as td_time,avg(td_count) as td_count").order("date_trunc('day',td_time)")
      else
        #集計
        tdtable = Tdtable.where(:td_time => startday .. endday).group("date_trunc('day',td_time)").select("date_trunc('day',td_time) as td_time,sum(td_count) as td_count").order("date_trunc('day',td_time)")
      end
    elsif term == 3 then  #年:１ヶ月ごとのデータを表示する。
      if graph.analysis_type == 1 then #集計タイプ : graph.analysis_type 0:集計、1:平均
        #平均
        tdtable = Tdtable.where(:td_time => startday .. endday).group("date_trunc('month',td_time)").select("date_trunc('month',td_time) as td_time,avg(td_count) as td_count").order("date_trunc('month',td_time)")
      else
        #集計
        tdtable = Tdtable.where(:td_time => startday .. endday).group("date_trunc('month',td_time)").select("date_trunc('month',td_time) as td_time,sum(td_count) as td_count").order("date_trunc('month',td_time)")
      end
    else   #0か指定なしは１日の集計 : 時間別データを表示する
      if graph.analysis_type == 1 then #集計タイプ : graph.analysis_type 0:集計、1:平均
        #平均
        tdtable = Tdtable.where(:td_time => startday .. endday).group("date_trunc('hour',td_time)").select("date_trunc('hour',td_time) as td_time,avg(td_count) as td_count").order("date_trunc('hour',td_time)")
      else
        #集計
        tdtable = Tdtable.where(:td_time => startday .. endday).group("date_trunc('hour',td_time)").select("date_trunc('hour',td_time) as td_time,sum(td_count) as td_count").order("date_trunc('hour',td_time)")
      end
    end
    return tdtable
  end
  
  # グラフ表示期間の設定
  def set_graph_term(graph_term,today,addcnt)
    case graph_term
    when 0 # 日の時間別のデータを表示する
      today = today - 1.day
      today = today + addcnt.to_i.days # 追加日数
      oldday = today
      term_s = today.month.to_s + t("datetime.prompts.month") + today.day.to_s + t("datetime.prompts.day")
      graphx = t("datetime.prompts.hour")
      stime = "%H"
    when 1  # 週:７日分の日別データを表示する
      today = today + (addcnt.to_i * 7).days # 追加日数
      # 月曜日から開始するように調整
      today = today + (7-today.wday).days
      oldday = today - 6.days
      term_s = oldday.month.to_s + t("datetime.prompts.month") + oldday.day.to_s + t("datetime.prompts.day") + " - " + today.month.to_s + t("datetime.prompts.month") + today.day.to_s + t("datetime.prompts.day")
      graphx = t("datetime.prompts.day")
      stime = "%d"
    when 2  # 月:１ヶ月分のデータを表示する
      today = today + addcnt.to_i.months # 追加日数
      # 月初から開始するように調整
      nowmonth = Date::new(today.year,today.month, 1)
      today = nowmonth >> 1
      today = today - 1.day
      oldday = nowmonth
      term_s = oldday.year.to_s + t("datetime.prompts.year") + oldday.month.to_s + t("datetime.prompts.month")
      graphx = t("datetime.prompts.day")
      stime = "%d"
    when 3  # 年:１ヶ月ごとのデータを表示する。
      today = today + addcnt.to_i.years # 追加日数
      # 年初から開始するように調整
      nowyear = Date::new(today.year,1, 1)
      today = nowyear + 1.year - 1.day
      oldday = nowyear
      term_s = oldday.year.to_s + t("datetime.prompts.year")
      graphx = t("datetime.prompts.month")
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
      enum = 24
    when 1 # 週
      snum = oldday.day.to_i
      enum = today.day.to_i
      if enum < snum then # 週間表示の場合で月をまたいでしまったときの処理
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
        if ddy.td_time.strftime(stime.to_s).to_i == dd then
          ydata = ydata + "," + ddy.td_count.to_i.to_s
          flg =false
          break
        end
      end
      if flg then # 値が存在しない場合は0を設定
        ydata = ydata + ",0"
      end 
    end
    # 月をまたいでしまったときの特別処理
    if weekflg then
      for dd in snum2 .. enum2
        xdata = xdata + "," + dd.to_s
        flg = true
        tdtable.each do |ddy|
          if ddy.td_time.strftime(stime).to_i == dd then
            ydata = ydata + "," + ddy.td_count.to_i.to_s
            flg =false
            break
          end
        end
        if flg then # 値が存在しない場合は0を設定
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
