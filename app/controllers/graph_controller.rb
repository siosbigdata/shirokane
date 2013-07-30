#coding: utf-8
# GraphController
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# グラフの表示
class GraphController < ApplicationController
  before_filter :authorize, :except => :login #ログインしていない場合はログイン画面に移動
  def index
  end
end
