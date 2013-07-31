#coding: utf-8
# DashboardsController
# Author:: Kazuko Ohmura
# Date:: 2013.07.31

#ダッシュボード
class DashboardsController < ApplicationController
  before_filter :authorize, :except => :login #ログインしていない場合はログイン画面に移動
  def index
  end
end
