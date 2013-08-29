class CreateGroupgraphs < ActiveRecord::Migration
  def change
    create_table :groupgraphs do |t|
      t.integer :group_id
      t.integer :graph_id
      t.boolean :dashboard
      t.integer :view_rank

      t.timestamps
    end
  end
end
