class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.string :title
      t.string :mail
      t.integer :group_id
      t.boolean :admin
      t.string :auth_token
      t.string :password_reset_token
      t.datetime :password_reset_sent_at

      t.timestamps
    end
  end
end
