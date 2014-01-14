#coding: utf-8
# GraphsController
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# グラフ管理用コントローラー
class Admin::GraphsController < AdminController
  before_filter :admin_authorize, :except => :login #ログインしていない場合はログイン画面に移動
  before_action :set_admin_graph, only: [:show, :edit, :update]
  before_action :set_select_items, only: [:index, :show,:edit]

  # グラフ一覧画面
  def index
    @admin_graphs = Admin::Graph.all.order(:id)
  end

  # グラフ詳細画面
  def show
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
      @h_analysis_types = {0 => t('analysis_types_sum'),1 => t('analysis_types_avg')}
      @h_graph_types = {0 => t('graph_types_line'),1 => t('graph_types_bar')}
      @h_terms ={0=> t('datetime.prompts.day'),1 => t('week'),2 => t('datetime.prompts.month'),3 => t('datetime.prompts.year')}
      @h_yesno={0=> t('title_no'),1 => t('title_yes')} 
      @h_template = Hash.new()
      tmp = Admin::Graphtemplate.all.order(:name)
      tmp.each do |tt|
        @h_template[tt.name.to_s] = tt.name.to_s
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_graph_params
      params.require(:admin_graph).permit(:name, :title, :analysis_type,:graph_type, :term, :y,:y_min,:y_max_time,:y_max_day,:y_max_month,:template,:useval,:useshadow,:usetip,:linewidth,:usepredata,:uselastyeardata,:y_unit,:merge_linecolor,:merge_graph)
    end
end
