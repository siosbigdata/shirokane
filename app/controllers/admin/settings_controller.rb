#coding: utf-8
# Admin::Settings Controller
# Author:: Kazuko Ohmura
# Date:: 2013.07.30

# 管理用パラメーター管理
class Admin::SettingsController < AdminController
  before_filter :admin_authorize, :except => :login #ログインしていない場合はログイン画面に移動
  before_action :set_admin_setting, only: [:show, :edit, :update]
  before_action :set_select_setting, only: [:index,:show, :edit, :update]

  # GET /admin/settings
  # GET /admin/settings.json
  def index
    # vieworder = 0は非表示
    @admin_settings = Admin::Setting.where.not(:vieworder => 0).order(:vieworder)
  end

  # GET /admin/settings/1
  # GET /admin/settings/1.json
  def show
  end

  # GET /admin/settings/1/edit
  def edit
  end

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_setting
      @admin_setting = Admin::Setting.find(params[:id])
    end
    
    def set_select_setting
      @select_yes_no ={"yes"=>"yes","no"=>"no"}
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_setting_params
      params.require(:admin_setting).permit(:name, :title, :parameter)
    end
end
