class AddNameToGraphtemplates < ActiveRecord::Migration
  def change
    add_column :graphtemplates, :name, :string
  end
end
