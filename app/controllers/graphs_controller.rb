class GraphsController < ApplicationController
  before_filter :authorize, :except => :login #ログインしていない場合はログイン画面に移動
  def index
  end
end
