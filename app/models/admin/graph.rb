class Admin::Graph < ActiveRecord::Base
  #テーブル名の指定
  self.table_name = 'graphs'
  #入力チェック
  validates :name,  :presence => true,:uniqueness=>true
  validates :title,  :presence => true
end
