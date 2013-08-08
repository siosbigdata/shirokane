class CreateGraphtemplates < ActiveRecord::Migration
  def change
    create_table :graphtemplates do |t|
      t.string :linecolor
      t.string :bgfrom
      t.string :bgto
      t.string :textcolor
      t.integer :useshadow
      t.string  :name

      t.timestamps
    end
  end
end
