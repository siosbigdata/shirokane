class Admin::GroupsController < ApplicationController
  before_filter :admin_authorize, :except => :login #ログインしていない場合はログイン画面に移動
  before_action :set_admin_group, only: [:show, :edit, :update, :destroy]

  # GET /admin/groups
  # GET /admin/groups.json
  def index
    @admin_groups = Admin::Group.all
  end

  # GET /admin/groups/1
  # GET /admin/groups/1.json
  def show
  end

  # GET /admin/groups/new
  def new
    @admin_group = Admin::Group.new
  end

  # GET /admin/groups/1/edit
  def edit
  end

  # POST /admin/groups
  # POST /admin/groups.json
  def create
    @admin_group = Admin::Group.new(admin_group_params)

    respond_to do |format|
      if @admin_group.save
        format.html { redirect_to @admin_group, notice: 'Group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @admin_group }
      else
        format.html { render action: 'new' }
        format.json { render json: @admin_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/groups/1
  # PATCH/PUT /admin/groups/1.json
  def update
    respond_to do |format|
      if @admin_group.update(admin_group_params)
        format.html { redirect_to @admin_group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @admin_group.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def select
    @graph = Admin::Graph.all
  end

  # DELETE /admin/groups/1
  # DELETE /admin/groups/1.json
  def destroy
    @admin_group.destroy
    respond_to do |format|
      format.html { redirect_to admin_groups_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_group
      @admin_group = Admin::Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_group_params
      params.require(:admin_group).permit(:name, :title)
    end
end
