#coding: utf-8
# PublichtmlController
# Author:: Kazuko Ohmura
# Date:: 2013.08.02

# グラフ表示用共通コントローラー
class PublichtmlController < ApplicationController
  # 通常ユーザ用-現在のアカウント設定
  def current_user
    if session[:user_id] && $settings && session[:servicename] == $settings['servicename'] then
      @current_user ||= User.find(session[:user_id])
    end
  end
  helper_method :current_user
    
  # ログインチェック
  def authorize
    unless current_user
      flash[:notice] = t('login_notice')
      session[:jumpto] = request.parameters
      redirect_to login_index_path
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