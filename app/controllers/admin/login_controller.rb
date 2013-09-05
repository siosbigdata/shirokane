#coding: utf-8
# Admin LoginController
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# 管理画面のログイン
class Admin::LoginController < AdminController
  # ログイン画面
  def index
  end
  
  # ユーザのログイン処理を行う
  def create
    user = Admin::User.find_by_mail params[:mail]

    if user && user.authenticate(params[:pass]) && user.admin
      session[:admin_user_id] = user.id
      settings = Setting.where(:name => 'servicename')
      session[:admin_servicename] = settings[0].parameter
      redirect_to admin_root_path
    else
      flash.now.alert = "Invalid"
      @errormsg = {'msg' => 'error'}
      render "index"
    end
  end
  
  # ユーザのログアウト処理を行う
  def destroy
    session[:admin_user_id] = nil
    session[:admin_servicename] = nil
    #redirect_to root_path
    render "index"
  end
end
