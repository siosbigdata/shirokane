#coding: utf-8
# User Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# ユーザテーブル
# == テーブル作成
# rails generate model user name:string title:string password_digest:string mail:string group_id:integer admin:boolean
class User < ActiveRecord::Base
    # パスワード用処理
    has_secure_password
    
    # グループ一覧用
    belongs_to :group
    
    # 入力チェック
    #validates :name,  :presence => true,:uniqueness=>true
    validates :title,  :presence => true
    validates :mail,  :presence => true,:uniqueness=>true, :email_format => {:message => I18n.t('error_mail_message')}
end
