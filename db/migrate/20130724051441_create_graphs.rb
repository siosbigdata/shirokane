class CreateGraphs < ActiveRecord::Migration
  def change
    create_table :graphs do |t|
      t.string :name
      t.string :title
      t.integer :analysis_type
      t.integer :graph_type
      t.integer :term
      t.string :y
      t.integer :y_max
      t.integer :y_min
      t.integer :linewidth
      t.string  :template
      t.integer :useval
      t.integer :useshadow
          
      t.timestamps
    end
  end
end
