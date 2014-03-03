#coding: utf-8
# Admin UsersController
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# ユーザー管理
class Admin::UsersController < AdminController
  before_filter :admin_authorize, :except => :login #ログインしていない場合はログイン画面に移動
  before_action :set_admin_user, only: [:show, :edit, :update, :destroy]

  # ユーザー一覧
  def index
    @admin_users = Admin::User.all.order(:id)
    @maxuser = Admin::User.get_maxuser
  end

  # ユーザー詳細
  def show
  end

  # ユーザー新規追加
  def new
    admin_users = Admin::User.all
    if admin_users.length < Admin::User.get_maxuser
      @admin_user = Admin::User.new
    else
      redirect_to admin_users_url
    end
  end

  # ユーザー編集画面
  def edit
  end

  # ユーザー新規作成
  def create
    @admin_user = Admin::User.new(admin_user_params)

    respond_to do |format|
      if @admin_user.save
        format.html { redirect_to @admin_user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @admin_user }
      else
        format.html { render action: 'new' }
        format.json { render json: @admin_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # ユーザー更新
  def update
    respond_to do |format|
      if @admin_user.update(admin_user_params)
        format.html { redirect_to @admin_user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @admin_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # ユーザー削除
  def destroy
    @admin_user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_user
      @admin_user = Admin::User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_user_params
      params.require(:admin_user).permit(:name, :password,:password_confirmation, :title, :mail, :group_id, :admin)
    end
end
