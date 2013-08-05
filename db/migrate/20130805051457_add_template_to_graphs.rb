class AddTemplateToGraphs < ActiveRecord::Migration
  def change
    add_column :graphs, :template, :string
  end
end
