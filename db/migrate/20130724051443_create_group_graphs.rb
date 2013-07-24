class CreateGroupGraphs < ActiveRecord::Migration
  def change
    create_table :group_graphs do |t|
      t.integer :group
      t.integer :graph

      t.timestamps
    end
  end
end
