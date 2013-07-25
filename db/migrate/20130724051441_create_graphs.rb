class CreateGraphs < ActiveRecord::Migration
  def change
    create_table :graphs do |t|
      t.string :name
      t.string :title
      t.integer :gtype
      t.integer :term
      t.string :x
      t.string :y

      t.timestamps
    end
  end
end
