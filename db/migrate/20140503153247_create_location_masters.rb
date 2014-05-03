class CreateLocationMasters < ActiveRecord::Migration
  def change
    create_table :location_masters do |t|
      t.string :client
      t.string :warehouse
      t.string :channel
      t.string :building
      t.string :location_type
      t.string :area
      t.string :zone
      t.string :aisle
      t.string :bay
      t.string :level
      t.string :position
      t.string :barcode
      t.string :climate_control
      t.string :minimum_temp
      t.string :maximum_temp
      t.string :lot_control_only
      t.string :serial_nbr_only
      t.string :single_sku_locn
      t.string :dedicated_sku_locn
      t.string :defalt_putaway_type
      t.string :secured_locn_type
      t.integer :maximum_wgt
      t.integer :length
      t.integer :height
      t.integer :width
      t.integer :volume
      t.string :preffered_pallet_type
      t.integer :maximum_pallets
      t.string :preffered_case_type
      t.integer :maximum_cases
      t.integer :minimum_units
      t.integer :maximum_units
      t.string :combine_locn
      t.string :equipment_type
      t.string :record_status
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
      t.string :attribute11
      t.string :attribute12
      t.string :attribute13
      t.string :attribute14
      t.string :attribute15
      t.string :attribute16
      t.string :attribute17
      t.string :attribute18
      t.string :attribute19
      t.string :attribute20
      t.string :attribute21
      t.string :attribute22
      t.string :attribute23
      t.string :attribute24
      t.string :attribute25
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
    drop_table :location_masters
  end
end
