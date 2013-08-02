#coding: utf-8
# PublichtmlController
# Author:: Kazuko Ohmura
# Date:: 2013.08.02

require 'pp'

# グラフ表示用共通コントローラー
class PublichtmlController < ApplicationController
  # 通常ユーザ用-現在のアカウント設定
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    helper_method :current_user
    
  # ログインチェック
    def authorize
      unless current_user
        flash[:notice] = t('login_notice')
        session[:jumpto] = request.parameters
        redirect_to :controller => 'login', :action => 'index'
      end
    end
    
  #graphメニュー作成
    def current_graph_menu
      if current_user then
        @current_graph_menu = Graph.joins(:groupgraph).where(:groupgraphs=>{:group_id=>current_user.group.id}).order(:title)
      end
    end
    helper_method :current_graph_menu
    
  # グラフ用データの取得
    def td_graph_data(graph_name,graph_term,analysis_type,startday,endday)
      # 表示テーブル名の設定
      Tdtable.table_name = "td_" + graph_name
      #SQLの作成
      if graph_term == 1 || graph_term == 2 then  # 週、月:日別データを表示する
        if analysis_type == 1 then #集計タイプ : analysis_type 0:集計、1:平均
          #平均
          tdtable = Tdtable.where(:td_time => startday .. endday).group("date_trunc('day',td_time)").select("date_trunc('day',td_time) as td_time,avg(td_count) as td_count").order("date_trunc('day',td_time)")
        else
          #集計
          tdtable = Tdtable.where(:td_time => startday .. endday).group("date_trunc('day',td_time)").select("date_trunc('day',td_time) as td_time,sum(td_count) as td_count").order("date_trunc('day',td_time)")
        end
      elsif graph_term == 3 then  #年:１ヶ月ごとのデータを表示する。
        if analysis_type == 1 then #集計タイプ : analysis_type 0:集計、1:平均
          #平均
          tdtable = Tdtable.where(:td_time => startday .. endday).group("date_trunc('month',td_time)").select("date_trunc('month',td_time) as td_time,avg(td_count) as td_count").order("date_trunc('month',td_time)")
        else
          #集計
          tdtable = Tdtable.where(:td_time => startday .. endday).group("date_trunc('month',td_time)").select("date_trunc('month',td_time) as td_time,sum(td_count) as td_count").order("date_trunc('month',td_time)")
        end
      else   #0か指定なしは１日の集計 : 時間別データを表示する
        if analysis_type == 1 then #集計タイプ : analysis_type 0:集計、1:平均
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