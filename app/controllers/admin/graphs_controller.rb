#coding: utf-8
# GraphsController
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# グラフ管理用コントローラー
class Admin::GraphsController < AdminController
  before_filter :admin_authorize, :except => :login #ログインしていない場合はログイン画面に移動
  before_action :set_admin_graph, only: [:show, :edit, :update]
  before_action :set_select_items, only: [:index, :show,:edit, :update,:new,:create]

  # グラフ一覧画面
  def index
    @admin_graphs = Admin::Graph.all.order(:id)
  end

  # グラフ詳細画面
  def show
  end

  # グラフ新規追加
  def new
    @admin_graph = Admin::Graph.new
    @newflg = true  # フラグ
    
    # 初期値を入力
    @admin_graph.term = 2   # 期間(月)
    @admin_graph.linewidth = 2  # 線の太さ
    @admin_graph.y_min = 0 # Y軸最小値
    @admin_graph.y_max_time = 100   # Y軸最大値-時
    @admin_graph.y_max_day = 100    # Y軸最大値-日
    @admin_graph.y_max_month = 100  # Y軸最大値-月
  end

  # グラフ新規作成
  def create
    @admin_graph = Admin::Graph.new(admin_graph_params)
    @newflg = true  # フラグ

    respond_to do |format|
      if @admin_graph.save
        format.html { redirect_to @admin_graph, notice: 'Graph was successfully created.' }
        format.json { render action: 'show', status: :created, location: @admin_graph }
      else
        format.html { render action: 'new' }
        format.json { render json: @admin_graph.errors, status: :unprocessable_entity }
      end
    end
  end
        
  # グラフ編集画面
  def edit
  end

  # グラフの更新
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_graph
      @admin_graph = Admin::Graph.find(params[:id])
    end
    
    #選択肢の設定
    def set_select_items
      @graph_settings = Admin::Graph::SETTINGS

      @h_template = Hash.new()
      tmp = Admin::Graphtemplate.all.order(:name)
      tmp.each do |tt|
        @h_template[tt.name.to_s] = tt.name.to_s
      end

#      @merge = Admin::Graph.get_use_merge_graph  # グラフのマージ機能を利用させるかどうか
#      @usecreate = Admin::Graph.get_use_create_graph # グラフの新規追加機能を利用させるかどうか
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_graph_params
      params.require(:admin_graph).permit(:name, :title, :analysis_type,:graph_type, :term, :y,:y_min,:y_max_time,:y_max_day,:y_max_month,:template,:useval,:useshadow,:usetip,:linewidth,:usepredata,:uselastyeardata,:y_unit,:merge_linecolor,:merge_graph)
    end
end
