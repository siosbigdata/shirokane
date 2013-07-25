class Admin::HomeController < ApplicationController
  before_filter :admin_authorize, :except => :login #ログインしていない場合はログイン画面に移動
  
  def index
  end
end
