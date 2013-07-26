class CreateGroupDashboards < ActiveRecord::Migration
  def change
    create_table :group_dashboards do |t|
      t.integer :group_id
      t.integer :graph_id
      t.integer :view_rank

      t.timestamps
    end
  end
end
