#coding: utf-8
# Setting Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.30

# パラメータモデル
# == 作成
# rails generate model setting name:string title:string parameter:string vieworder:integer columntype:integer
# == 初期データ
# vieworder 表示順、columntype 1:text 2:yesno 3:数値 4:画面サイズ  ※0の場合は非表示
class Setting < ActiveRecord::Base
end
