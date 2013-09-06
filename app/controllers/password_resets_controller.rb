#coding: utf-8
# PasswordResetsController
# Author:: Kazuko Ohmura
# Date:: 2013.08.30
# == 参考にしたページ
# http://ja.asciicasts.com/episodes/274-remember-me-reset-password

# パスワードの再設定処理
class PasswordResetsController < PublichtmlController
  # パスワード設定画面
  def new
  end
  
  # パスワード再作成
  def create
    user = User.find_by_mail(params[:email])
    user.send_password_reset if user
    redirect_to root_url, :notice => "Email sent with password reset instructions."
  end
  
  # パスワード更新画面
  def edit
    session[:user_id] = nil
    session[:servicename] = nil
    @user = User.find_by_password_reset_token!(params[:id])
  end
  
  # パスワード更新
  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 12.hours.ago
      redirect_to root_url, :alert => "Password reset has expired."
    elsif @user.update_attributes(params.require(:user).permit(:password, :password_confirmation))
      redirect_to root_url, :notice => "Password has been reset!"
    else
      render :edit
    end
  end
end
