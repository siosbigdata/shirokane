#coding: utf-8
# UsersController
# Author:: Kazuko Ohmura
# Date:: 2013.07.31

#require 'date'
#require 'active_support'

#グラフ表示
class GraphsController < ApplicationController
  before_filter :authorize, :except => :login #ログインしていない場合はログイン画面に移動
  
  # 表示用処理
  def show
    @h_analysis_types = {0 => t('analysis_types_sum'),1 => t('analysis_types_avg')}
    @h_terms ={0=> t('terms_day'),1 => t('terms_week'),2 => t('terms_month'),3 => t('terms_year')}
          
    #指定グラフ情報
    @graph = Graph.find(params[:id])
      
    #グラフ選択枝
    @graph_types = ['line','bar','pie']
    
    #設定の取得
    ss = Setting.all
    @gconf = Hash.new()
    ss.map{|s|
      @gconf[s.name] = s.parameter
    }
    
    #表示期間指定
    if params[:term] then
      @graph_term = params[:term].to_i
    else
      @graph_term = @graph.term
    end
    
    #期間移動分
    @today = Date.today
    @add = 0
    if params[:add] then
      @add = params[:add].to_i
      case @graph_term
      when 0 # 日
        @today = @today + @add.days
      when 1 # 週
        @today = @today + (@add*7).days
      when 2 # 月
        @today = @today + @add.months
      when 3 # 年
        @today = @today + @add.years
      end
    end
      
    
    
    #表示テーブル名の設定
    Tdtable.table_name = "td_" + @graph.name
    
    #SQLの作成
    if @graph_term == 1 || @graph_term == 2 then
      #期間の設定
      if @graph_term == 1 then
        #週:７日分の日別データを表示する
        @oldday = @today - 7.days
      else
        #月:１ヶ月分のデータを表示する
        @oldday = @today - 1.month
      end
      #式の作成
      if @graph.analysis_type == 1 then #集計タイプ : analysis_type 0:集計、1:平均
        #平均
        #@tdtable = Tdtable.where(:td_time => @oldday .. @today).group('td_time::DATE').select('td_time::DATE as td_time,avg(td_count) as td_count').order('td_time::DATE')
        @tdtable = Tdtable.where(:td_time => @oldday .. @today).group("date_part('day',td_time)").select("date_part('day',td_time) as td_time,avg(td_count) as td_count").order("date_part('day',td_time)")
      else
        #集計
        #@tdtable = Tdtable.where(:td_time => @oldday .. @today).group('td_time::DATE').select('td_time::DATE as td_time,sum(td_count) as td_count').order('td_time::DATE')
        @tdtable = Tdtable.where(:td_time => @oldday .. @today).group("date_part('day',td_time)").select("date_part('day',td_time) as td_time,sum(td_count) as td_count").order("date_part('day',td_time)")
      end
      @term = @oldday.month.to_s + "." + @oldday.day.to_s + " - " + @today.month.to_s + "." + @today.day.to_s
    elsif @graph_term == 3 then
      #年:１ヶ月ごとのデータを表示する。
      @oldday = @today - 1.year
      if @graph.analysis_type == 1 then #集計タイプ : analysis_type 0:集計、1:平均
        #平均
        @tdtable = Tdtable.where(:td_time => @oldday .. @today).group("date_part('month',td_time)").select("date_part('month',td_time) as td_time,avg(td_count) as td_count").order("date_part('month',td_time)")
      else
        #集計
        @tdtable = Tdtable.where(:td_time => @oldday .. @today).group("date_part('month',td_time)").select("date_part('month',td_time) as td_time,avg(td_count) as td_count").order("date_part('month',td_time)")
      end
      @term = @oldday.year.to_s + "." + @oldday.month.to_s + " - " + @today.year.to_s + "." + @today.month.to_s
    else
      #0か指定なしは１日の集計
      @oldday = @today.to_s + " 00:00:00"
      @today_s = @today.to_s + " 23:59:59"
      if @graph.analysis_type == 1 then #集計タイプ : analysis_type 0:集計、1:平均
        #平均
        #@tdtable = Tdtable.where(:td_time => @oldday .. @today).group('td_time::HOUR').select('td_time::HOUR as td_time,avg(td_count) as td_count').order('td_time::HOUR')
        @tdtable = Tdtable.where(:td_time => @oldday .. @today_s).group("date_part('hour',td_time)").select("date_part('hour',td_time) as td_time,avg(td_count) as td_count").order("date_part('hour',td_time)")
      else
        #集計
        #@tdtable = Tdtable.where(:td_time => @oldday .. @today).order(:td_time).select('extract(hour from td_time) as td_time,td_count')
        #@tdtable = Tdtable.where(:td_time => @oldday .. @today).group('td_time::HOUR').select('td_time::HOUR as td_time,sum(td_count) as td_count').order('td_time::HOUR')
        @tdtable = Tdtable.where(:td_time => @oldday .. @today_s).group("date_part('hour',td_time)").select("date_part('hour',td_time) as td_time,sum(td_count) as td_count").order("date_part('hour',td_time)")
      end
      @term = @today.month.to_s + "." + @today.day.to_s
    end
    

    #@tdtable = Tdtable.all
    #@tdtable = Tdtable.where(:td_time => @oldday .. @today).group_by_day(:td_time)
    #@tdtable = Tdtable.where(:td_time => @oldday .. @today).group('td_time::DATE').select('td_time::DATE as td_time,sum(td_count) as td_count')
    @xdata = ""
    @ydata = ""
    @tdtable.each do |dd|
      @xdata = @xdata + "," + dd.td_time.to_s
      @ydata = @ydata + "," + dd.td_count.to_i.to_s
    end
  end
end
