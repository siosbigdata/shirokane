class CreateGraphs < ActiveRecord::Migration
  def change
    create_table :graphs do |t|
      t.string :name
      t.string :title
      t.integer :analysis_type
      t.integer :graph_type
      t.integer :term
      t.string :y
      t.integer :y_min
      t.integer :y_max_time
      t.integer :y_max_day
      t.integer :y_max_month
      t.integer :linewidth
      t.string  :template
      t.integer :useval
      t.integer :useshadow
      t.integer :usetip
          
      t.timestamps
    end
  end
end
