class CreateGroupDashboards < ActiveRecord::Migration
  def change
    create_table :group_dashboards do |t|
      t.integer :group
      t.integer :graph1
      t.integer :graph2
      t.integer :graph3
      t.integer :graph4

      t.timestamps
    end
  end
end
