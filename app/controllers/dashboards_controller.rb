#coding: utf-8
# DashboardsController
# Author:: Kazuko Ohmura
# Date:: 2013.07.31

#ダッシュボード
class DashboardsController < PublichtmlController
  before_filter :authorize, :except => :login #ログインしていない場合はログイン画面に移動
  
  # ダッシュボード用
  def index
    #グラフ選択枝
    @graph_types = ['line','bar','pie']
    @h_yesno = {0=>'no' , 1 => 'yes'}
    
    #設定の取得
    ss = Setting.all
    @gconf = Hash.new()
    ss.map{|s|
      @gconf[s.name] = s.parameter
    }
        
    # ダッシュボード情報取得
    @dashboards = Groupdashboard.where({:group_id=>current_user.group.id}).order(:view_rank)
    @graphs = Array.new()
    @template = Array.new()
    @xdatas = Array.new()
    @ydatas = Array.new()
    @terms = Array.new()
    
    @dashboards.each do |db|
      if db.graph_id > 0 then
        # データの取得
        graph = Graph.find(db.graph_id)
        # 指定テンプレート情報
        templates = Graphtemplate.where({:name => graph.template})
        template = templates[0]
            
        #期間移動分
        today = Date.today
        
        #期間の設定
        case graph.term
        when 1  #週:７日分の日別データを表示する
          oldday = today - 7.days
          term = oldday.month.to_s + "." + oldday.day.to_s + " - " + today.month.to_s + "." + today.day.to_s
          stime = "%d"
        when 2  #月:１ヶ月分のデータを表示する
          oldday = today - 1.month
          term = oldday.month.to_s + "." + oldday.day.to_s + " - " + today.month.to_s + "." + today.day.to_s
          stime = "%d"
        when 3  #年:１ヶ月ごとのデータを表示する。
          oldday = today - 1.year
          term = oldday.year.to_s + "." + oldday.month.to_s + " - " + today.year.to_s + "." + today.month.to_s
          stime = "%m"
        else    #0か指定なしは１日の集計
          oldday = today
          term = today.month.to_s + "." + today.day.to_s
          stime = "%H"
        end
  
        # データ取得期間の設定
        today_s = today.to_s + " 23:59:59"
        oldday_s = oldday.to_s + " 00:00:00"
        # データの取得
        tdtable = td_graph_data(graph.name,graph.term,graph.analysis_type,oldday_s,today_s)
    
        # グラフ表示用データ作成
        xdata = ""
        ydata = ""
        tdtable.each do |dd|
          xdata = xdata + "," + dd.td_time.strftime(stime)
          ydata = ydata + "," + dd.td_count.to_i.to_s
        end
        @graphs[db.view_rank.to_i] = graph
        @template[db.view_rank.to_i] = template
        @xdatas[db.view_rank.to_i] = xdata
        @ydatas[db.view_rank.to_i] = ydata
        @terms[db.view_rank.to_i] = term
      end
    end
  end
end
