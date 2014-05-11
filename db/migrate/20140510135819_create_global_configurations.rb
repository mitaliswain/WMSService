class CreateGlobalConfigurations < ActiveRecord::Migration
  def change
    create_table :global_configurations do |t|
      t.string :client
      t.string :warehouse
      t.string :channel
      t.string :building
      t.integer :sequence_no
      t.string :module
      t.string :module_description
      t.string :submodule1
      t.string :submodule2
      t.string :submodule3
      t.string :submodule4
      t.string :submodule5
      t.string :user
      t.string :user_role
      t.integer :app_id
      t.string :key
      t.string :value
      t.string :attribute1
      t.string :attribute2
      t.string :attribute3
      t.string :attribute4
      t.string :attribute5
      t.string :attribute6
      t.string :attribute7
      t.string :attribute8
      t.string :attribute9
      t.string :attribute10
      t.boolean :enable
      t.datetime :created_date
      t.string :created_user
      t.string :created_prc
      t.datetime :update_date
      t.string :updated_user
      t.string :updated_prc

      t.timestamps
    end
  end
  def down
    drop_table :global_configurations
  end
end
