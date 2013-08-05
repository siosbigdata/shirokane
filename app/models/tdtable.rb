#coding: utf-8
# Tdtable Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.31

# TreasureData用データモデル
# == テーブル作成(postgresql)
# create table td_xxx(td_time timestamp with time zone,td_count decimal);
# xxx部分はGraph.nameとそろえる
class Tdtable < ActiveRecord::Base
  #テーブル名の指定
  self.table_name = 'td_test1'
end
