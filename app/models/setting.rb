#coding: utf-8
# Setting Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.30

# パラメータモデル
# == 作成
# rails generate model setting name:string title:string parameter:string vieworder:integer columntype:integer
# == 初期データ
# vieworder 表示順、columntype 1:text 2:yesno 3:数値 4:画面サイズ  ※0の場合は非表示
# rails c
# Setting.create(:name  => "admin_mail",  :title  =>  "管理者：メール", :parameter => "k-omura@sios.com",:vieworder => 1,:columntype => 0)
# Setting.create(:name => "title" ,:title => "アプリケーションタイトル",:parameter => "SIOS DashBoard" ,:vieworder => 2,:columntype => 0)
# Setting.create(:name => "dashboardnum" ,:title => "ダッシュボードに並べるグラフ数",:parameter => "3" ,:vieworder => 10,:columntype => 3)
# Setting.create(:name => "sessionnum" ,:title => "同時ログイン数",:parameter => "3" ,:vieworder => 0,:columntype => 3)
# Setting.create(:name => "servicename" ,:title => "サービス名",:parameter => "shirokane" ,:vieworder => 0,:columntype => 0)  # 一意なservicenameを指定
# Setting.create(:name => "csvdownloadsize" ,:title => "最大CSVダウンロード容量",:parameter => "100000" ,:vieworder => 0,:columntype => 3)  # 上限は自由
# Setting.create(:name => "maxuser" ,:title => "最大ユーザ数",:parameter => "5" ,:vieworder => 0,:columntype => 3)  # 上限は自由
# Setting.create(:name => "useMarker" ,:title => "マーカーの種類",:parameter => "css-ring" ,:vieworder => 0,:columntype => 0) # css-maruも指定可能
# Setting.create(:name => "markerWidth" ,:title => "マーカーの大きさ",:parameter => "1" ,:vieworder => 11,:columntype => 3)
class Setting < ActiveRecord::Base
end
