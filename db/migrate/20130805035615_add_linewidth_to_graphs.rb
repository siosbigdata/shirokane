class AddLinewidthToGraphs < ActiveRecord::Migration
  def change
    add_column :graphs, :linewidth, :integer
  end
end
