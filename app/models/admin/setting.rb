#coding: utf-8
# Admin::Setting Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.30

# 管理用パラメーターテーブル
# == テーブル作成
# rails generate model setting name:string title:string parameter:string vieworder:integer columntype:integer
# == 初期データ
# Setting.create(:name  => "admin_mail",  :title  =>  "管理者：メール", :parameter => "k-omura@sios.com",:vieworder => 1,:columntype => 0)
# Setting.create(:name => "title" ,:title => "アプリケーションタイトル",:parameter => "SIOS DashBoard" ,:vieworder => 2,:columntype => 0)
# Setting.create(:name => "graphsize" ,:title => "グラフの大きさ",:parameter => "1" ,:vieworder => 10,:columntype => 1)
class Admin::Setting < ActiveRecord::Base
  #テーブル名の指定
  self.table_name = 'settings'
  
  # 入力チェック
  validates :parameter,  :presence => true
end
