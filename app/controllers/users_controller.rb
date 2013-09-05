#coding: utf-8
# UsersController
# Author:: Kazuko Ohmura
# Date:: 2013.07.31

#ユーザ情報更新
class UsersController < PublichtmlController
    before_filter :authorize, :except => :login #ログインしていない場合はログイン画面に移動
    # 更新画面
    def edit
      @user = current_user
    end
  
    # 更新処理
    def update
      @user = current_user
      respond_to do |format|
        if @user.update(user_params)
          @successmsg = {'msg'=>'success'}
          format.html { render action: 'edit' }
          format.json { render json: @successmsg }
        else
          format.html { render action: 'edit' }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
    
    private
      # Never trust parameters from the scary internet, only allow the white list through.
      def user_params
        params.require(:user).permit(:name, :password,:password_confirmation, :title, :mail, :group_id, :admin)
      end
end
