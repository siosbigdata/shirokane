class CreateAdminGroupgraphs < ActiveRecord::Migration
  def change
    create_table :groupgraphs do |t|
      t.integer :group_id
      t.integer :graph_id

      t.timestamps
    end
  end
end
