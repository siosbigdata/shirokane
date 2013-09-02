#coding: utf-8
# Group Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# グループテーブル
# == テーブル作成
# rails generate model group name:string title:string
# == 初期データ作成
# rails c
# Group.create(:name => "addmingroup", :title => "管理グループ")
class Group < ActiveRecord::Base
end
