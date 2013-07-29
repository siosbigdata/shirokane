#coding: utf-8
# Groupdashboards Controller
# Author:: Kazuko Ohmura
# Date:: 2013.07.29

require 'pp'

class Admin::GroupdashboardsController < ApplicationController
  # GET /admin/groupdashboards/1/list
  def list
    #@groupid = params[:id]
    @graph = Admin::Graph.all.order(:id)
    @group = Admin::Group.find(params[:id])
    @dashboard = Admin::Groupdashboard.where({:group_id => params[:id]}).all
#    @groupgraph = Admin::Groupgraph.where(:group_id => params[:id]).order(:graph_id)
#    pp @groupgraph
#    p 'test'
    @ghash = Hash.new()
    @graph.each do |g|
      @ghash[g.id] = ''
      @dashboard.each do |db|
        if g.id == db.graph_id then
          @ghash[g.id] = db.view_rank
        end
      end
    end
    
    pp @ghash
    pp @dashboard
  end
  
  #関連グラフの更新
  def create
    gid = params[:groupid]
#    p gid
    vr = params[:viewrank]
 #   pp vr
    #対象group_idのレコードを削除
    Admin::Groupdashboard.delete_all(:group_id  => gid)
    #対象レコードの新規追加
#    vr.each do |ggs|
#      @gg = Admin::Groupdashboard.new
#      @gg.group_id = gid
#      @gg.graph_id = ggs
#      @gg.save
#    end
    
    redirect_to "/admin/groups"
      
  end
end
