#coding: utf-8
# AdminController
# Author:: Kazuko Ohmura
# Date:: 2013.08.02

# 管理画面用共通コントローラー
class AdminController < ApplicationController
  # 管理者用-現在のアカウント設定
  def admin_current_user
    @admin_current_user ||= User.find(session[:admin_user_id]) if session[:admin_user_id]
  end
  helper_method :admin_current_user
    
  # 管理者ログインチェック
  def admin_authorize
    unless admin_current_user
      flash[:notice] = t('login_notice')
      session[:jumpto] = request.parameters
      redirect_to :controller => 'login', :action => 'index'
    end
  end
end