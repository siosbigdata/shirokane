#coding: utf-8
# Admin::Groupdashboard Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# 管理用グループダッシュボードモデル
# == テーブル作成
# rails generate model groupdashboard group_id:integer graph_id:integer view_rank:integer
class Admin::Groupdashboard < ActiveRecord::Base
  #テーブル名の指定
  self.table_name = 'groupdashboards'

end
