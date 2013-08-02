#coding: utf-8
# LoginController
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# グラフ表示画面のログイン処理
class LoginController < PublichtmlController
    def index
    end
    
    # ユーザのログイン処理を行う
    def create
      user = User.find_by_mail params[:mail]
      if user && user.authenticate(params[:pass])
        session[:user_id] = user.id
        redirect_to root_path
      else
        flash.now.alert = "Invalid"
        @errormsg = {'msg'=>'error'}
        render "index"
      end
    end
    
    # ユーザのログアウト処理を行う
    def destroy
      session[:user_id] = nil
      #redirect_to root_path
      render "index"
    end
end
