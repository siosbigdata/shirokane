#coding: utf-8
# Groupdashboards Controller
# Author:: Kazuko Ohmura
# Date:: 2013.07.29

# グループ別でダッシュボードに表示するグラフを管理
class Admin::GroupdashboardsController < AdminController
  
  def index
    @admin_groupdashboard = Admin::Groupdashboard.new
  end
  
  # GET /admin/groupdashboards/1/list
  def list
    #selected用hash
    @hrank = Hash.new()
    for rank in 1..4 do
      tmp = Admin::Groupdashboard.where(:group_id=>params[:id],:view_rank => rank)
      if tmp[0].nil? then
        #対象レコードが存在しない場合は新規追加
        newdash = Admin::Groupdashboard.new
        newdash.group_id = params[:id]
        newdash.graph_id = 0
        newdash.view_rank = rank
        newdash.save
        @hrank[rank] = ''
      else
        if tmp[0].graph_id == 0 then
          @hrank[rank] = ''
        else
          @hrank[rank] = tmp[0].graph_id
        end
      end
    end
    
    #利用グループ情報
    @group = Admin::Group.find(params[:id])
    #登録用
    @admin_groupdashboard = Admin::Groupdashboard.find_by_group_id(params[:id])
    #選択肢グラフ
    @graph = Admin::Graph.joins(:groupgraph).where(:groupgraphs=>{:group_id=>params[:id]})
  end
  
  #関連グラフの更新
  def create
    gid = params[:group_id]   #グループイID
    graphs = params[:graphs]  #グラフID一覧

    #対象group_idのレコードを削除
    Admin::Groupdashboard.delete_all(:group_id  => gid)
    #対象レコードの新規追加
    graphs.keys.each do |k|
      if graphs[k] == "" then
        g_id = 0
      else
        g_id = graphs[k]
      end
      @gg = Admin::Groupdashboard.new
      @gg.group_id = gid
      @gg.graph_id = g_id
      @gg.view_rank = k;
      @gg.save
    end
    
    redirect_to "/admin/groups"
      
  end
end
