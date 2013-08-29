class CreateGraphs < ActiveRecord::Migration
  def change
    create_table :graphs do |t|
      t.string :name
      t.string :title
      t.integer :analysis_type
      t.integer :graph_type
      t.integer :term
      t.string :x
      t.string :y
      t.integer :y_max
      t.integer :y_min
      t.integer :analysis_type
      t.integer :useval
      t.integer :linewidth
      t.string  :template
          
      t.timestamps
    end
  end
end
