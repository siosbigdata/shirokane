#coding: utf-8
# Groupgraphs Controller
# Author:: Kazuko Ohmura
# Date:: 2013.07.29

require 'pp'

#グループとグラフの結びつきを管理する
class Admin::GroupgraphsController < ApplicationController

  # GET /admin/groupgraphs/1/list
  def list
    #@groupid = params[:id]
    @graph = Admin::Graph.all.order(:id)
    @group = Admin::Group.find(params[:id])
#    @groupgraph = Admin::Groupgraph.where(:group_id => params[:id]).order(:graph_id)
#    pp @groupgraph
    p 'test'
    @ghash = Hash.new()
    @graph.each do |g|
      @ghash[g.id] = ''
      if Admin::Groupgraph.exists?({:group_id => params[:id],:graph_id => g.id}) then
#      @groupgraph.each do |gg|
#        if g.id == gg.graph_id then
        @ghash[g.id] = 'checked'
#        end
      end
    end
  end
  
  #関連グラフの更新
  def create
    gid = params[:groupid]
    p gid
    gs = params[:groupgraph]
    pp gs
    #対象group_idのレコードを削除
    Admin::Groupgraph.delete_all(:group_id  => gid)
    #対象レコードの新規追加
    gs.keys.each do |ggs|
      @gg = Admin::Groupgraph.new
      @gg.group_id = gid
      @gg.graph_id = ggs
      @gg.save
    end
    
    redirect_to "/admin/groups"
      
  end
end

