#coding: utf-8
# Admin::Groupdashboard Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

class Admin::Groupdashboard < ActiveRecord::Base
  #テーブル名の指定
  self.table_name = 'groupdashboards'
  #グラフ一覧用
  #belongs_to :graph
end
