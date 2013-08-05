class AddUseshadowToGraphtemplates < ActiveRecord::Migration
  def change
    add_column :graphtemplates, :useshadow, :integer
  end
end
