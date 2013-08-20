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
  
  # 通常ユーザ用-現在のアカウント設定
  def application_title
    settings = Setting.where(:name => 'title')
    @application_title = settings[0].parameter
  end
  helper_method :application_title
  
  # テーブル名取得
  def get_td_tablename(name)
    return "td_" + name
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
end
