#coding: utf-8
# HomeController
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# ログイン時、非ログイン時の挙動を管理
class Admin::HomeController < AdminController
  before_filter :admin_authorize, :except => :login #ログインしていない場合はログイン画面に移動
  
  # ダッシュボード（グラフ一覧表示）
  def index
      #グラフ選択枝
      @graph_types = ['line','bar','pie']
      @h_yesno = {0=>'no' , 1 => 'yes'}
      @h_analysis_types = {0 => t('analysis_types_sum'),1 => t('analysis_types_avg')}
  
      #設定の取得
      ss = Setting.all
      @gconf = Hash.new()
      ss.map{|s|
        @gconf[s.name] = s.parameter
      }
          
      # ダッシュボード情報取得
      @graphs = Admin::Graph.all.order(:id)
      @template = Array.new()
      @xdatas = Array.new()
      @ydatas = Array.new()
      @terms = Array.new()
      
      @graphs.each do |graph|
        # 指定テンプレート情報
        templates = Graphtemplate.where({:name => graph.template})
        template = templates[0]
            
        #期間移動分
        today = Date.today
        
        #期間の設定
        case graph.term
        when 1  #週:７日分の日別データを表示する
          # 月曜日から開始するように調整
          today = today + (7-today.wday).days
          oldday = today - 6.days
          term = oldday.month.to_s + t("datetime.prompts.month") + oldday.day.to_s + t("datetime.prompts.day") + " - " + today.month.to_s + t("datetime.prompts.month") + today.day.to_s + t("datetime.prompts.day")
          stime = "%d"
        when 2  #月:１ヶ月分のデータを表示する
          # 月初から開始するように調整
          nowmonth = Date::new(today.year,today.month, 1)
          today = nowmonth >> 1
          today = today - 1.day
          oldday = nowmonth
          term = oldday.month.to_s + t("datetime.prompts.month")
          stime = "%d"
        when 3  #年:１ヶ月ごとのデータを表示する。
          # 年初から開始するように調整
          nowyear = Date::new(today.year,1, 1)
          today = nowyear + 1.year - 1.day
          oldday = nowyear
          term = oldday.year.to_s + t("datetime.prompts.year")
          stime = "%m"
        else    #0か指定なしは１日の集計
          today = today - 1.day
          oldday = today
          term = today.month.to_s + t("datetime.prompts.month") + today.day.to_s + t("datetime.prompts.day")
          stime = "%H"
        end
  
        # データ取得期間の設定
        today_s = today.to_s + " 23:59:59"
        oldday_s = oldday.to_s + " 00:00:00"
        # データの取得
        tdtable = td_graph_data(graph,graph.term,oldday_s,today_s)
    
        # グラフ表示用データ作成
        xdata = ""
        ydata = ""
# add 9/6
        weekflg = false
        if graph.term == 1 || graph.term == 2 then # 週or月
          snum = oldday.day.to_i
          enum = today.day.to_i
          if enum < snum then # 週間表示の場合で月をまたいでしまったときの処理
            weekflg = true
            snum2 = 1
            enum2 = enum
            nm = Date::new(@today.year,@today.month, 1)
            eday = nm - 1.day
            enum = eday.day.to_i
          end
        elsif graph.term == 3 then # 年
          snum = oldday.month.to_i
          enum = today.month.to_i
        else # 日
          snum = 0
          enum = 24
        end
        
        # 値の設定
        for dd in snum .. enum
          xdata = xdata + "," + dd.to_s
          flg = true
          tdtable.each do |ddy|
            if ddy.td_time.strftime(stime).to_i == dd then
              ydata = ydata + "," + ddy.td_count.to_i.to_s
              flg =false
              break
            end
          end
          if flg then
            ydata = ydata + ",0"
          end 
        end
        # 月をまたいでしまったときの特別処理
        if weekflg then
          for dd in snum2 .. enum2
            xdata = xdata + "," + dd.to_s
            flg = true
            tdtable.each do |ddy|
              if ddy.td_time.strftime(stime).to_i == dd then
                ydata = ydata + "," + ddy.td_count.to_i.to_s
                flg =false
                break
              end
            end
            if flg then
              ydata = ydata + ",0"
            end 
          end
        end 

#        tdtable.each do |dd|
#          xdata = xdata + dd.td_time.strftime(stime) + ","
#          ydata = ydata + dd.td_count.to_i.to_s + ","
#        end
        #@graphs[db.view_rank.to_i] = graph
        @template << template
        @xdatas  << xdata
        @ydatas  << ydata
        @terms << term
      end
    end
end
