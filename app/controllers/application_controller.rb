#coding: utf-8
# ApplicationController
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# ApplicationController
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  protect_from_forgery
  
  # 通常ユーザ用-現在のアカウント設定
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
  
  # 管理者用-現在のアカウント設定
  def admin_current_user
    @admin_current_user ||= User.find(session[:admin_user_id]) if session[:admin_user_id]
  end
  helper_method :admin_current_user
  
  # ログインチェック
  def authorize
    unless current_user
      flash[:notice] = t('login_notice')
      session[:jumpto] = request.parameters
      redirect_to :controller => 'login', :action => 'index'
    end
  end
  
  # 管理者ログインチェック
  def admin_authorize
    unless admin_current_user
      flash[:notice] = t('login_notice')
      session[:jumpto] = request.parameters
      redirect_to :controller => 'login', :action => 'index'
    end
  end
 
  #graphメニュー作成
  def current_graph_menu
    if current_user then
      @current_graph_menu = Graph.joins(:groupgraph).where(:groupgraphs=>{:group_id=>current_user.group.id})
      #@current_graph_menu = Graph.joins(:groupgraph).all
      #@current_graph_menu = Groupgraph.all
    end
  end
  helper_method :current_graph_menu
    
end
