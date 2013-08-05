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
  def application_title
    settings = Setting.where(:name => 'title')
    @application_title = settings[0].parameter
  end
  helper_method :application_title
end
