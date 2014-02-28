#coding: utf-8
# Tdtable Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.31

# TreasureData用データモデル
# == 作成(postgresql)
# create table td_xxx(td_time timestamp with time zone,td_count decimal);
# xxx部分はGraph.nameとそろえる
class Tdtable < ActiveRecord::Base
  class << self
    def graph_data graph, term
      # 表示テーブル名の設定
      self.table_name = "td_#{graph.name}"
      adapter = configurations[Rails.env]["adapter"]
      #SQLの作成
      self.send("set_#{adapter}_sql", graph, term)
    end

    def set_mysql2_sql graph, term
      graph_term = graph.term
      if graph_term == 1 || graph_term == 2 # 週、月:日別データを表示する
        table_arel = self.where(:td_time => term["start"] .. term["end"])
        if graph.analysis_type == 1 #集計タイプ : graph.analysis_type 0:集計、1:平均
          #平均
          tdtable = table_arel.group("date_format(td_time, '%d')").select("date_format(td_time, '%d') as td_time,avg(td_count) as td_count").order("date_format(td_time, '%d')")
        else
          #集計
          tdtable = table_arel.group("date_format(td_time, '%d')").select("date_format(td_time, '%d') as td_time,sum(td_count) as td_count").order("date_format(td_time, '%d')")
        end
      elsif graph_term == 3   #年:１ヶ月ごとのデータを表示する。
        if graph.analysis_type == 1  #集計タイプ : graph.analysis_type 0:集計、1:平均
          #平均
          tdtable = table_arel.group("date_format(td_time, '%m')").select("date_format(td_time, '%m') as td_time,avg(td_count) as td_count").order("date_format(td_time, '%m')")
        else
          #集計
          tdtable = table_arel.group("date_format(td_time, '%m')").select("date_format(td_time, '%m') as td_time,sum(td_count) as td_count").order("date_format(td_time, '%m')")
        end
      else   #0か指定なしは１日の集計 : 時間別データを表示する
        if graph.analysis_type == 1  #集計タイプ : graph.analysis_type 0:集計、1:平均
          #平均
          tdtable = table_arel.group("date_format(td_time, '%h')").select("date_format(td_time, '%h') as td_time,avg(td_count) as td_count").order("date_format(td_time, '%h')")
        else
          #集計
          tdtable = table_arel.group("date_format(td_time, '%h')").select("date_format(td_time, '%h') as td_time,sum(td_count) as td_count").order("date_format(td_time, '%h')")
        end
      end
      return tdtable
    end

    def set_pg_sql graph, term
      graph_term = graph.term
      if graph_term == 1 || graph_term == 2 # 週、月:日別データを表示する
        table_arel = self.where(:td_time => term["start"] .. term["end"])
        if graph.analysis_type == 1 #集計タイプ : graph.analysis_type 0:集計、1:平均
          #平均
          tdtable = table_arel.group("date_trunc('day',td_time)").select("date_trunc('day',td_time) as td_time,avg(td_count) as td_count").order("date_trunc('day',td_time)")
        else
          #集計
          tdtable = table_arel.group("date_trunc('day',td_time)").select("date_trunc('day',td_time) as td_time,sum(td_count) as td_count").order("date_trunc('day',td_time)")
        end
      elsif graph_term == 3   #年:１ヶ月ごとのデータを表示する。
        if graph.analysis_type == 1  #集計タイプ : graph.analysis_type 0:集計、1:平均
          #平均
          tdtable = table_arel.group("date_trunc('month',td_time)").select("date_trunc('month',td_time) as td_time,avg(td_count) as td_count").order("date_trunc('month',td_time)")
        else
          #集計
          tdtable = table_arel.group("date_trunc('month',td_time)").select("date_trunc('month',td_time) as td_time,sum(td_count) as td_count").order("date_trunc('month',td_time)")
        end
      else   #0か指定なしは１日の集計 : 時間別データを表示する
        if graph.analysis_type == 1  #集計タイプ : graph.analysis_type 0:集計、1:平均
          #平均
          tdtable = table_arel.group("date_trunc('hour',td_time)").select("date_trunc('hour',td_time) as td_time,avg(td_count) as td_count").order("date_trunc('hour',td_time)")
        else
          #集計
          tdtable = table_arel.group("date_trunc('hour',td_time)").select("date_trunc('hour',td_time) as td_time,sum(td_count) as td_count").order("date_trunc('hour',td_time)")
        end
      end
      return tdtable
    end
  end

end
