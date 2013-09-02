#coding: utf-8
# PublichtmlController
# Author:: Kazuko Ohmura
# Date:: 2013.08.02

# グラフ表示用共通コントローラー
class PublichtmlController < ApplicationController
  # 通常ユーザ用-現在のアカウント設定
  def current_user
    #@current_user ||= User.find(session[:user_id]) if session[:user_id]
    #@current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
    if session[:user_id] then
      @current_user ||= User.find(session[:user_id])
    elsif cookies[:auth_token]
      @current_user ||= User.find_by_auth_token!(cookies[:auth_token])
    end
  end
  helper_method :current_user
    
  # ログインチェック
  def authorize
    unless current_user
      flash[:notice] = t('login_notice')
      session[:jumpto] = request.parameters
      redirect_to :controller => 'login', :action => 'index'
    end
  end
    
  #graphメニュー作成
  def current_graph_menu
    if current_user then
      @current_graph_menu = Graph.joins(:groupgraph).where(:groupgraphs=>{:group_id=>current_user.group.id}).order(:id)
    end
  end
  helper_method :current_graph_menu

end