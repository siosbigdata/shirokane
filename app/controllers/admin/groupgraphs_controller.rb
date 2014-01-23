#coding: utf-8
# Groupgraphs Controller
# Author:: Kazuko Ohmura
# Date:: 2013.07.29

# グループとグラフの結びつきを管理する
class Admin::GroupgraphsController < AdminController
  # グループごとのグラフ一覧表示
  def list
    @graph = Admin::Graph.all.order(:id)
    @group = Admin::Group.find(params[:id])
    @ghash = Hash.new()
    @gcheck = Hash.new()
    @graph.each do |g|
      if Admin::Groupgraph.exists?({:group_id => params[:id],:graph_id => g.id}) 
        tmp = Admin::Groupgraph.where(:group_id => params[:id],:graph_id => g.id) 
        
        if tmp[0].view_rank.to_i < 1
          tmp[0].view_rank = 99
        end 
        @gcheck[g.id] = true
        @ghash[g.id] = tmp[0]
      else 
        tmp = Admin::Groupgraph.new
        tmp.dashboard = false
        tmp.view_rank = 99
        @gcheck[g.id] = false
        @ghash[g.id] = tmp
      end
    end
  end
  
  # 関連グラフの更新
  def create
    gid = params[:group_id]
    gs = params[:groupgraph]
    ds = params[:dashboard]
    graph = Admin::Graph.all.order(:id)
    #対象group_idのレコードを削除
    Admin::Groupgraph.delete_all(:group_id  => gid)
    #対象レコードの新規追加
    if not gs.nil?
      gs.keys.each do |ggs|
        @gg = Admin::Groupgraph.new
        @gg.group_id = gid
        @gg.graph_id = ggs
        if not ds.nil? and not ds[ggs.to_s].nil? 
          @gg.dashboard = true
        else
          @gg.dashboard = false
        end
        @gg.view_rank = params['view_rank' + ggs.to_s]
        @gg.save
      end
    end
    
    redirect_to admin_groups_path
  end
end

