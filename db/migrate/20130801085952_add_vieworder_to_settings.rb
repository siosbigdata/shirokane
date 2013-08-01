class AddVieworderToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :vieworder, :integer
  end
end
