class Admin::Group < ActiveRecord::Base
  self.table_name = 'groups'
  #入力チェック
  validates :name,  :presence => true,:uniqueness=>true
  validates :title,  :presence => true,:uniqueness=>true
end
