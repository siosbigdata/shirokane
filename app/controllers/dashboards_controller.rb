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
    @h_analysis_types = {0 => t('analysis_types_sum'),1 => t('analysis_types_avg')}
        
    # ダッシュボード情報取得
    @dashboards = Groupgraph.where(:group_id=>current_user.group.id,:dashboard => true).order(:view_rank)
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
        template = Graphtemplate.find_by_name(graph.template)
            
        #期間移動分
        today = Date.today
        
        # 期間の設定
        res_graph_terms = set_graph_term(graph.term,today,0)
        today = res_graph_terms['today']
        oldday = res_graph_terms['oldday']
  
        # データ取得期間の設定
        today_s = today.to_s + " 23:59:59"
        oldday_s = oldday.to_s + " 00:00:00"
        # データの取得
        tdtable = td_graph_data(graph,graph.term,oldday_s,today_s)

        # グラフ表示用データ作成
        res_graph_data = set_graph_data(tdtable,graph.term,oldday,today,res_graph_terms['stime'])
              
        @graphs[db.graph_id.to_i] = graph
        @template[db.graph_id.to_i] = template
        @xdatas[db.graph_id.to_i] = res_graph_data['xdata']
        @ydatas[db.graph_id.to_i] = res_graph_data['ydata']
        @terms[db.graph_id.to_i] = res_graph_terms['term_s']
      end
    end
  end
end
