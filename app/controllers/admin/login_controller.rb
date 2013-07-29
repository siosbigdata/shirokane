#coding: utf-8
# Admin LoginController
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

#管理者のログイン
class Admin::LoginController < ApplicationController
  def index
  end
    
  def create
    user = Admin::User.find_by_name params[:name]

    if user && user.authenticate(params[:pass]) && user.admin
      session[:admin_user_id] = user.id
      redirect_to "/admin/"
    else
      flash.now.alert = "Invalid"
      render "index"
    end
  end
  
  def destroy
    session[:admin_user_id] = nil
    #redirect_to root_path
    render "index"
  end
end
