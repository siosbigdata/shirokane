class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  protect_from_forgery
  
  #通常ユーザ用
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
  #管理者用
  def admin_current_user
    @admin_current_user ||= User.find(session[:admin_user_id]) if session[:admin_user_id]
  end
    helper_method :admin_current_user
  
  #ログインチェック
  def authorize
    unless current_user
      flash[:notice] = t('login_notice')
      session[:jumpto] = request.parameters
      redirect_to :controller => 'login', :action => 'index'
    end
  end
  
  #管理者ログインチェック
  def admin_authorize
    unless admin_current_user
      flash[:notice] = t('login_notice')
      session[:jumpto] = request.parameters
      redirect_to :controller => 'login', :action => 'index'
    end
  end
 
    
end
