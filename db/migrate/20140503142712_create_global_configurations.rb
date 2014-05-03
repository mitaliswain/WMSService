class CreateGlobalConfigurations < ActiveRecord::Migration
  def change
    create_table :global_configurations do |t|
      t.string :client
      t.string :warehouse
      t.string :channel
      t.string :building
      t.integer :sequence_no
      t.string :module_description
      t.string :config_code
      t.string :config_description
      t.string :applied_at
      t.string :config_attribute1
      t.string :config_attribute2
      t.string :config_attribute3
      t.string :config_attribute4
      t.string :config_attribute5
      t.boolean :enable
      t.boolean :disable
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
