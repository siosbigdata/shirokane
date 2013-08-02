#coding: utf-8
# GraphsController
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

#require 'pp'

# グラフ管理用コントローラー
class Admin::GraphsController < AdminController
  before_filter :admin_authorize, :except => :login #ログインしていない場合はログイン画面に移動
  before_action :set_admin_graph, only: [:show, :edit, :update]
  before_action :set_select_items, only: [:index, :show,:edit]

  # GET /admin/graphs
  # GET /admin/graphs.json
  def index
    @admin_graphs = Admin::Graph.all.order(:id)
  end

  # GET /admin/graphs/1
  # GET /admin/graphs/1.json
  def show
  end

#  # GET /admin/graphs/new
#  def new
#    @admin_graph = Admin::Graph.new
#  end

  # GET /admin/graphs/1/edit
  def edit
  end

#  # POST /admin/graphs
#  # POST /admin/graphs.json
#  def create
#    @admin_graph = Admin::Graph.new(admin_graph_params)
#
#    respond_to do |format|
#      if @admin_graph.save
#        format.html { redirect_to @admin_graph, notice: 'Graph was successfully created.' }
#        format.json { render action: 'show', status: :created, location: @admin_graph }
#      else
#        format.html { render action: 'new' }
#        format.json { render json: @admin_graph.errors, status: :unprocessable_entity }
#      end
#    end
#  end

  # PATCH/PUT /admin/graphs/1
  # PATCH/PUT /admin/graphs/1.json
  def update
    respond_to do |format|
      if @admin_graph.update(admin_graph_params)
        format.html { redirect_to @admin_graph, notice: 'Graph was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @admin_graph.errors, status: :unprocessable_entity }
      end
    end
  end

#  # DELETE /admin/graphs/1
#  # DELETE /admin/graphs/1.json
#  def destroy
#    # 削除前に関連するテーブルの削除を行う
#    Admin::Groupgraph.delete_all(:graph_id  => @admin_graph.id)     #グループ-グラフ
#    Admin::Groupdashboard.delete_all(:graph_id  => @admin_graph.id) #グループ-ダッシュボード
#    # destory
#    @admin_graph.destroy
#    respond_to do |format|
#      format.html { redirect_to admin_graphs_url }
#      format.json { head :no_content }
#    end
#  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_graph
      @admin_graph = Admin::Graph.find(params[:id])
    end
    
    #選択肢の設定
    def set_select_items
      @h_analysis_types = {0 => t('analysis_types_sum'),1 => t('analysis_types_avg')}
      @h_graph_types = {0 => t('graph_types_line'),1 => t('graph_types_bar')}
      @h_terms ={0=> t('terms_day'),1 => t('terms_week'),2 => t('terms_month'),3 => t('terms_year')}
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_graph_params
      params.require(:admin_graph).permit(:name, :title, :analysis_type,:graph_type, :term, :x, :y)
    end
end
