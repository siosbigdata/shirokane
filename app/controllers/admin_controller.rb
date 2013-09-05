#coding: utf-8
# AdminController
# Author:: Kazuko Ohmura
# Date:: 2013.08.02

# 管理画面用共通コントローラー
class AdminController < ApplicationController
  # 管理者用-現在のアカウント設定
  def admin_current_user
    settings = Setting.where(:name => 'servicename')
    servicename = settings[0].parameter
    if session[:admin_user_id] && session[:admin_servicename] == servicename then
      @admin_current_user ||= User.find(session[:admin_user_id])
    end
  end
  helper_method :admin_current_user
    
  # 管理者ログインチェック
  def admin_authorize
    unless admin_current_user
      flash[:notice] = t('login_notice')
      session[:jumpto] = request.parameters
      redirect_to admin_login_index_path
    end
  end
end