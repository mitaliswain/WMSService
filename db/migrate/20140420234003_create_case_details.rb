class CreateCaseDetails < ActiveRecord::Migration
  def change
    create_table :case_details do |t|
      t.string :client
      t.string :warehouse
      t.string :channel
      t.string :building
      t.integer :case_header_id
      t.string :case_id
      t.integer :sequence
      t.string :pallet_id
      t.string :status
      t.string :item
      t.string :sku_attribute1
      t.string :sku_attribute2
      t.string :sku_attribute3
      t.string :sku_attribute4
      t.string :sku_attribute5
      t.string :sku_attribute6
      t.string :sku_attribute7
      t.string :sku_attribute8
      t.string :sku_attribute9
      t.string :sku_attribute10
      t.string :concept
      t.string :description
      t.string :short_desc
      t.string :barcode
      t.string :inventory_type
      t.integer :quantity
      t.integer :allocated_qty
      t.string :purchase_order_nbr
      t.integer :poline_nbr
      t.string :shipment_nbr
      t.integer :shipment_line_nbr
      t.string :vendor_nbr
      t.string :vendor_factory
      t.string :coo
      t.string :lot_control_nbr
      t.string :serial_nbr
      t.integer :unit_weight
      t.integer :unit_volume
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
    drop_table :case_details
   end
end

