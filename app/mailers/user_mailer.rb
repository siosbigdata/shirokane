#coding: utf-8
# UserMailer
# Author:: Kazuko Ohmura
# Date:: 2013.08.30

# メール送信用
class UserMailer < ActionMailer::Base
  default from: "admin@oss-dashboard.com"  
  # パスワードリセットメール送信
  def password_reset(user)
    @user = user
    mail :to => user.mail, :subject => t('message_password_reset')
  end
end
