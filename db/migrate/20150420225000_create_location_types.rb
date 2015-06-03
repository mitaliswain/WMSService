class CreateLocationTypes < ActiveRecord::Migration
  def change
    create_table :location_types do |t|
      t.string :client
      t.string :warehouse
      t.string :channel
      t.string :building
      t.string :location_type
      t.string :description
      t.string :notes
      t.string :climate_control
      t.string :minimum_temp
      t.string :maximum_temp
      t.string :lot_control_only
      t.string :serial_nbr_only
      t.string :single_sku_locn
      t.string :default_putaway_type
      t.string :secured_locn_type
      t.integer :maximum_wgt
      t.integer :maximum_len
      t.integer :maximum_hgt
      t.integer :maximum_wdt
      t.datetime :created_date
      t.string :created_by
      t.string :created_prc
      t.datetime :update_date
      t.string :updated_by
      t.string :updated_prc

      t.timestamps
    end
  end
end
