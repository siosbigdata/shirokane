#coding: utf-8
# Admin::Settings Controller
# Author:: Kazuko Ohmura
# Date:: 2013.07.30

# 管理用パラメーター管理
class Admin::SettingsController < AdminController
  before_filter :admin_authorize, :except => :login #ログインしていない場合はログイン画面に移動
  before_action :set_admin_setting, only: [:show, :edit, :update]

  # GET /admin/settings
  # GET /admin/settings.json
  def index
    @admin_settings = Admin::Setting.all.order(:vieworder)
  end

  # GET /admin/settings/1
  # GET /admin/settings/1.json
  def show
  end

#  # GET /admin/settings/new
#  def new
#    @admin_setting = Admin::Setting.new
#  end

  # GET /admin/settings/1/edit
  def edit
  end

#  # POST /admin/settings
#  # POST /admin/settings.json
#  def create
#    @admin_setting = Admin::Setting.new(admin_setting_params)
#
#    respond_to do |format|
#      if @admin_setting.save
#        format.html { redirect_to @admin_setting, notice: 'Setting was successfully created.' }
#        format.json { render action: 'show', status: :created, location: @admin_setting }
#      else
#        format.html { render action: 'new' }
#        format.json { render json: @admin_setting.errors, status: :unprocessable_entity }
#      end
#    end
#  end

  # PATCH/PUT /admin/settings/1
  # PATCH/PUT /admin/settings/1.json
  def update
    respond_to do |format|
      if @admin_setting.update(admin_setting_params)
        format.html { redirect_to @admin_setting, notice: 'Setting was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @admin_setting.errors, status: :unprocessable_entity }
      end
    end
  end

#  # DELETE /admin/settings/1
#  # DELETE /admin/settings/1.json
#  def destroy
#    @admin_setting.destroy
#    respond_to do |format|
#      format.html { redirect_to admin_settings_url }
#      format.json { head :no_content }
#    end
#  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_setting
      @admin_setting = Admin::Setting.find(params[:id])
      @select_yes_no ={"yes"=>"yes","no"=>"no"}
      @select_color = {"white" => "#FFFFFF","black"=>"#000000","red" => "#FF0000","gray1"=>"#687478","gray2"=>"#222222","blue"=>"#0000ff","yellow"=>"#ffcc00","green"=>"#006600"}
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_setting_params
      params.require(:admin_setting).permit(:name, :title, :parameter)
    end
end
