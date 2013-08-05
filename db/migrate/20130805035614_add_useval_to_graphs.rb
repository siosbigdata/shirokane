class AddUsevalToGraphs < ActiveRecord::Migration
  def change
    add_column :graphs, :useval, :integer
  end
end
