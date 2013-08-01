class AddColumntypeToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :columntype, :integer
  end
end
