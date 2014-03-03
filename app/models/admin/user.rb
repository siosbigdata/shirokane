#coding: utf-8
# Admin::User Model
# Author:: Kazuko Ohmura
# Date:: 2013.07.25

# 管理用ユーザモデル
class Admin::User < User
  #入力チェック
  validates :name,  :presence => true,:uniqueness=>true
  
  class << self
      # 最大登録ユーザー数
      def get_maxuser
        res = 999
        # 最大ダウンロード容量取得
        if $settings['maxuser']
          res = $settings['maxuser'].to_i
        end
        return res
      end
    end
end
