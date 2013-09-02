#coding: utf-8
# UserMailer
# Author:: Kazuko Ohmura
# Date:: 2013.08.30

# メール送信用
class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
#  def password_reset
#    @greeting = "Hi"
#
#    mail to: "to@example.org"
#  end
  
  def password_reset(user)
    @user = user
    mail :to => user.mail, :subject => "Password Reset"
  end
end
