#coding: utf-8
# HomeController
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# ログイン時、非ログイン時の挙動を管理
class Admin::HomeController < AdminController
  before_filter :admin_authorize, :except => :login #ログインしていない場合はログイン画面に移動

  # ダッシュボード（グラフ一覧表示）
  def index
      # ダッシュボード情報取得
      @graphs = Admin::Graph.all.order(:id)
      begin
        @dashboard_settings = @graphs.set_setting
      rescue => e
        #TODO メソッドが無かった場合の処理が未実装
        flash[:alert] = e
      end
    end
end
