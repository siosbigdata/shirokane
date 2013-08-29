class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :name
      t.string :title
      t.string :parameter
      t.integer :vieworder
      t.integer :columntype

      t.timestamps
    end
  end
end
