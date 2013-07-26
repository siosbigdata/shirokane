class CreateGroupGraphs < ActiveRecord::Migration
  def change
    create_table :group_graphs do |t|
      t.integer :group_id
      t.integer :graph_id

      t.timestamps
    end
  end
end
