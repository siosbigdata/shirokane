class AddTemplateIdToGraphs < ActiveRecord::Migration
  def change
    add_column :graphs, :integer
  end
end
