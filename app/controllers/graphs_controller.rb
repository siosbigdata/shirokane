#coding: utf-8
# UsersController
# Author:: Kazuko Ohmura
# Date:: 2013.07.31

require 'csv'

#グラフ表示
class GraphsController < PublichtmlController
  before_filter :authorize, :except => :login #ログインしていない場合はログイン画面に移動
  
  # グラフ用画面
  def index
    # グラフIDの指定が無い場合はルートへ移動
    redirect_to root_path
  end
  
  # csv出力処理
  def csvexport
    # 表示可能グラフチェック
    return redirect_to root_path if !check_graph_permission(params[:id]) 
    # CSVダウンロード権限チェック
    return redirect_to graph_path if check_csv_size == false

    # 指定グラフ情報
    @graph = Graph.find(params[:id])
      
    # 表示テーブル名の設定
    Tdtable.table_name = "td_" + @graph.name
    
    # 取得期間
    @start_day = params[:start];
    @end_day = params[:end];
    
    # データ取得
    @tdtable = Tdtable.where(:td_time => @start_day .. @end_day).order(:td_time)
    data = CSV.generate do |csv|
      csv << ["time", "value"]
      @tdtable.each do |td|
        csv << [td.td_time, td.td_count]
      end
    end
    
    # ファイル名
    fname =  @graph.name.to_s + "_#{Time.now.strftime('%Y_%m_%d_%H_%M_%S')}.csv"
      
    # 出力
    send_data(data, type: 'text/csv', filename: fname)
    
    # 出力データ容量記録
    today = Date.today # 今月の日付
    key = "csv_" + today.year.to_s + today.month.to_s
    tmp = Setting.find_by_name(key)
    if tmp then
      csize = tmp.parameter.to_i + data.size
      tmp.update_attribute(:parameter,csize)
    end
  end
  
  # 表示用処理
  def show
    # 表示可能グラフチェック
    return redirect_to root_path if !check_graph_permission(params[:id]) 
      
    # 値設定
    @h_analysis_types = {0 => t('analysis_types_sum'),1 => t('analysis_types_avg')}
    @h_terms ={0=> t('datetime.prompts.day'),1 => t('week'),2 => t('datetime.prompts.month'),3 => t('datetime.prompts.year')}
    @h_yesno = {0=>'no' , 1 => 'yes'}
    
    # CSVダウンロードボタン用フラグ
    @csvflg = check_csv_size
    
    # グラフ選択枝
    @graph_types = ['line','bar','pie']
          
    # 指定グラフ情報
    @graph = Graph.find(params[:id])

    # 指定テンプレート情報
    @template = Graphtemplate.find_by_name(@graph.template)
    
    # 表示期間指定
    if params[:term] then
      @graph_term = params[:term].to_i
    else
      @graph_term = @graph.term
    end
    
    # 基準日付
    @today = Date.today

    # 追加期間の設定
    if params[:add] then
      @add = params[:add].to_i
    else
      @add = 0
    end
    
    # 期間の設定
    res_graph_terms = set_graph_term(@graph_term,@today,@add)
    today = res_graph_terms['today']
    oldday = res_graph_terms['oldday']
    @term_s = res_graph_terms['term_s']
    @graphx = res_graph_terms['graphx']

    # データ取得期間の設定
    @today_s = today.to_s + " 23:59:59"
    @oldday_s = oldday.to_s + " 00:00:00"
    # データの取得
    tdtable = td_graph_data(@graph,@graph_term,@oldday_s,@today_s)
    
    # グラフ表示用データ作成
    res_graph_data = set_graph_data(tdtable,@graph_term,oldday,today,res_graph_terms['stime'])
    @xdata = res_graph_data['xdata']
    @ydata = res_graph_data['ydata']
  end


  private
  # グラフが利用可能かをチェックする
  def check_graph_permission(p_graph_id)
    return Groupgraph.exists?({:group_id=>current_user.group.id,:graph_id=>p_graph_id}) 
  end
  
  # 今月のCSVダウンロード容量チェック
  def check_csv_size
    if get_csv_size.to_i > $settings['csvdownloadsize'].to_i then
      res = false
    else
      res = true
    end
    return res
  end
  
  # 今月のCSVダウンロード容量取得
  def get_csv_size
    today = Date.today # 今月の日付
    key = "csv_" + today.year.to_s + today.month.to_s
    tmp = Setting.find_by_name(key)
    if tmp then
      # レコードが存在する
      res = tmp.parameter.to_i
    else
      # レコードが存在しない➡作成
      csvrow = Setting.new
      csvrow.name = key
      csvrow.title = key
      csvrow.parameter = 0
      csvrow.vieworder = 0
      csvrow.columntype = 0
      csvrow.save
      res = 0
    end
    return res
  end
end
