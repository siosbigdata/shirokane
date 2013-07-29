class CreateAdminGroupdashboards < ActiveRecord::Migration
  def change
    create_table :groupdashboards do |t|
      t.integer :group_id
      t.integer :graph_id
      t.integer :view_rank

      t.timestamps
    end
  end
end
