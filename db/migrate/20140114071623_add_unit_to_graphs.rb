class AddUnitToGraphs < ActiveRecord::Migration
  def change
    add_column :graphs, :y_unit, :string
    add_column :graphs, :merge_linecolor, :string
    add_column :graphs, :merge_graph, :string
  end
end
