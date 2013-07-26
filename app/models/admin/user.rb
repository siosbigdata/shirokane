class Admin::User < ActiveRecord::Base
  #テーブル名の指定
  self.table_name = 'users'
  #パスワード用処理
  has_secure_password
  #グループ一覧用
  belongs_to :group
  #入力チェック
  validates :name,  :presence => true,:uniqueness=>true
  validates :title,  :presence => true
  validates :mail,  :presence => true,:uniqueness=>true, :email_format => {:message => I18n.t('error_mail_message')}
end
