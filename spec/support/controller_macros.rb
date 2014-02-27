module ControllerMacros
  def login_admin_user
      before :each do
        user = FactoryGirl.create(:login_user)
        session[:admin_user_id] = nil
        session[:admin_user_id] = user.id
        session[:admin_servicename] = 'sitename'
     end
  end

  def set_setting
    before :each do
      # 下記グローバル変数のセットは
      # rspecはランダムにテストを実行する為indexが先に実行されない場合は、値がセットされていないので落ちてしまう(想定)問題
      # の対策として毎回呼ぶようにしている。
      ss = [
        { :name  => "admin_mail",  :title  =>  "管理者：メール", :parameter => "admin@sios.com",:vieworder => 1,:columntype => 0 },
        { :name => "title" ,:title => "アプリケーションタイトル",:parameter => "OSS-DashBoard" ,:vieworder => 2,:columntype => 0 },
        { :name => "dashboardnum" ,:title => "ダッシュボードに並べるグラフ数",:parameter => "3" ,:vieworder => 10,:columntype => 3 },
        { :name => "sessionnum" ,:title => "同時ログイン数",:parameter => "3" ,:vieworder => 0,:columntype => 3 },
        { :name => "servicename" ,:title => "サービス名",:parameter => "sitename" ,:vieworder => 0,:columntype => 0 },
        { :name => "csvdownloadsize" ,:title => "最大CSVダウンロード容量",:parameter => "32212254720" ,:vieworder => 0,:columntype => 3 },
        { :name => "maxuser" ,:title => "最大ユーザ数",:parameter => "5" ,:vieworder => 0,:columntype => 3 },
        { :name => "useMarker" ,:title => "マーカーの種類",:parameter => "css-ring" ,:vieworder => 0,:columntype => 0 },
        { :name => "markerWidth" ,:title => "マーカーの大きさ",:parameter => "1" ,:vieworder => 10,:columntype => 3 },
        { :name => "graph_width" ,:title => "グラフの横",:parameter => "720" ,:vieworder => 3,:columntype => 1 },
        { :name => "graph_height" ,:title => "グラフの縦",:parameter => "480" ,:vieworder => 4,:columntype => 1 },
        { :name => "use_merge_graph" ,:title => "グラフのマージ機能の利用",:parameter => "0" ,:vieworder => 0,:columntype => 1 },
        { :name => "use_create_graph" ,:title => "グラフの新規追加機能の利用",:parameter => "0" ,:vieworder => 0,:columntype => 1 }
      ]
      #FactoryGirl.create(:default_setting)
      $settings = Hash.new()
      ss.map{|s|
        $settings[s[:name].to_s] = s[:parameter].to_s
      }
    end
  end
end
