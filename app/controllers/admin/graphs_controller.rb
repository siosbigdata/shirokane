class Admin::GraphsController < ApplicationController
  before_filter :admin_authorize, :except => :login #ログインしていない場合はログイン画面に移動
  before_action :set_admin_graph, only: [:show, :edit, :update, :destroy]

  # GET /admin/graphs
  # GET /admin/graphs.json
  def index
    @admin_graphs = Admin::Graph.all
  end

  # GET /admin/graphs/1
  # GET /admin/graphs/1.json
  def show
  end

  # GET /admin/graphs/new
  def new
    @admin_graph = Admin::Graph.new
  end

  # GET /admin/graphs/1/edit
  def edit
  end

  # POST /admin/graphs
  # POST /admin/graphs.json
  def create
    @admin_graph = Admin::Graph.new(admin_graph_params)

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

  # DELETE /admin/graphs/1
  # DELETE /admin/graphs/1.json
  def destroy
    @admin_graph.destroy
    respond_to do |format|
      format.html { redirect_to admin_graphs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_graph
      @admin_graph = Admin::Graph.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_graph_params
      params.require(:admin_graph).permit(:name, :title, :type, :term, :x, :y)
    end
end
