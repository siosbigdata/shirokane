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
    templates = Graphtemplate.where({:name => @graph.template})
    @template = templates[0]
    
    #表示期間指定
    if params[:term] then
      @graph_term = params[:term].to_i
    else
      @graph_term = @graph.term
    end
    
    # 基準日付
    @today = Date.today

    #期間の設定
    @add = 0 #追加日数初期化
    @add = params[:add] if params[:add]
    case @graph_term
    when 1  #週:７日分の日別データを表示する
      @today = @today + (@add.to_i * 7).days if params[:add] # 追加日数
      # 月曜日から開始するように調整
      @today = @today + (7-@today.wday).days
      @oldday = @today - 6.days
      @term = @oldday.month.to_s + t("datetime.prompts.month") + @oldday.day.to_s + t("datetime.prompts.day") + " - " + @today.month.to_s + t("datetime.prompts.month") + @today.day.to_s + t("datetime.prompts.day")
      @graphx = t("datetime.prompts.day")
      stime = "%d"
    when 2  #月:１ヶ月分のデータを表示する
      @today = @today + @add.to_i.months if params[:add] # 追加日数
      # 月初から開始するように調整
      nowmonth = Date::new(@today.year,@today.month, 1)
      @today = nowmonth >> 1
      @today = @today - 1.day
      @oldday = nowmonth
      @term = @oldday.year.to_s + t("datetime.prompts.year") + @oldday.month.to_s + t("datetime.prompts.month")
      @graphx = t("datetime.prompts.day")
      stime = "%d"
    when 3  #年:１ヶ月ごとのデータを表示する。
      @today = @today + @add.to_i.years if params[:add] # 追加日数
      # 年初から開始するように調整
      nowyear = Date::new(@today.year,1, 1)
      @today = nowyear + 1.year - 1.day
      @oldday = nowyear
      @term = @oldday.year.to_s + t("datetime.prompts.year")
      @graphx = t("datetime.prompts.month")
      stime = "%m"
    else    #0か指定なしは１日の集計
      @today = @today - 1.day
      @today = @today + @add.to_i.days if params[:add] # 追加日数
      @oldday = @today
      @term = @today.month.to_s + t("datetime.prompts.month") + @today.day.to_s + t("datetime.prompts.day")
      @graphx = t("datetime.prompts.hour")
      stime = "%H"
    end

    # データ取得期間の設定
    @today_s = @today.to_s + " 23:59:59"
    @oldday_s = @oldday.to_s + " 00:00:00"
    # データの取得
    tdtable = td_graph_data(@graph,@graph_term,@oldday_s,@today_s)

    # グラフ表示用データ作成
    @xdata = ""
    @ydata = ""

    weekflg = false
    if @graph_term == 1 || @graph_term == 2 then # 週or月
      snum = @oldday.day.to_i
      enum = @today.day.to_i
      if enum < snum then # 週間表示の場合で月をまたいでしまったときの処理
        weekflg = true
        snum2 = 1
        enum2 = enum
        nm = Date::new(@today.year,@today.month, 1)
        eday = nm - 1.day
        enum = eday.day.to_i
      end
    elsif @graph_term == 3 then # 年
      snum = @oldday.month.to_i
      enum = @today.month.to_i
    else # 日
      snum = 0
      enum = 24
    end
    
    # 値の設定
    for dd in snum .. enum
      @xdata = @xdata + "," + dd.to_s
      flg = true
      tdtable.each do |ddy|
        if ddy.td_time.strftime(stime).to_i == dd then
          @ydata = @ydata + "," + ddy.td_count.to_i.to_s
          flg =false
          break
        end
      end
      if flg then
        @ydata = @ydata + ",0"
      end 
    end
    # 月をまたいでしまったときの特別処理
    if weekflg then
      for dd in snum2 .. enum2
        @xdata = @xdata + "," + dd.to_s
        flg = true
        tdtable.each do |ddy|
          if ddy.td_time.strftime(stime).to_i == dd then
            @ydata = @ydata + "," + ddy.td_count.to_i.to_s
            flg =false
            break
          end
        end
        if flg then
          @ydata = @ydata + ",0"
        end 
      end
    end 
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
