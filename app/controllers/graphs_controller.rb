#coding: utf-8
# UsersController
# Author:: Kazuko Ohmura
# Date:: 2013.07.31

#require 'date'
#require 'active_support'

#グラフ表示
class GraphsController < ApplicationController
  before_filter :authorize, :except => :login #ログインしていない場合はログイン画面に移動
  def index
  end
  def show
    @add = params[:add]
    @graph = Graph.find(params[:id])
    Tdtable.table_name = "td_" + @graph.name
    #取得するデータの期間を指定 "日" => 1 ,"週" => 2 ,"月" => 3 ,"年" => 4
    #select td_time::DATE from td_test1 group by td_time::DATE;
    @today = Date.today
    @today = @today - @add if @add
    case @graph.term
    when 2
      #週
      @oldday = @today - 7.days
      @tdtable = Tdtable.where(:td_time => @oldday .. @today).group('td_time::DATE').select('td_time::DATE as td_time,sum(td_count) as td_count').order('td_time::DATE')
    when 3
      #月
      @oldday = @today - 1.month
      @tdtable = Tdtable.where(:td_time => @oldday .. @today).group('td_time::DATE').select('td_time::DATE as td_time,sum(td_count) as td_count').order('td_time::DATE')
    when 4
      #年
      @oldday = @today - 1.year
      @tdtable = Tdtable.where(:td_time => @oldday .. @today).group('td_time::DATE').select('td_time::DATE as td_time,sum(td_count) as td_count').order('td_time::DATE')
    else
      #1か指定なしは１日の集計
      #@oldday = @today.yesterday
      #@tdtable = Tdtable.where('date_part("day",TIMESTAMP td_time) = ?',@today).order(:td_time)
      @oldday = @today.to_s + " 00:00:00"
      @today = @today.to_s + " 23:59:59"
      @tdtable = Tdtable.where(:td_time => @oldday .. @today).order(:td_time).select('extract(hour from td_time) as td_time,td_count')
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
