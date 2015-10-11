class CreateUserMasters < ActiveRecord::Migration
  def change
    create_table :user_masters do |t|
      t.string :client
      t.string :user_id
      t.string :password
      t.string :user_name
      t.string :preferred_warehouse
      t.string :preferred_landing_screen
      t.string :avatar_url
      t.string :authorized_warehouse
      t.string :authorized_action

      t.timestamps
    end
  end
end
