class CreateAsnDetails < ActiveRecord::Migration
  def change
    create_table :asn_details do |t|
      t.string :client
      t.string :warehouse
      t.string :channel
      t.string :building
      t.integer :asn_header_id
      t.string :asn_type
      t.string :purchase_order_nbr
      t.integer :poline_nbr
      t.string :shipment_nbr
      t.integer :sequence
      t.string :hot_item
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
      t.string :vendor_factory
      t.string :coo
      t.integer :innerpack_qty
      t.integer :standardcase_qty
      t.integer :po_qty
      t.integer :received_qty
      t.integer :verified_qty
      t.integer :cases_rcvd
      t.integer :cases_verified
      t.integer :unit_cost
      t.integer :landing_cost
      t.integer :retail_price
      t.string :uom
      t.integer :unit_wgt
      t.string :track_lotcontrol
      t.string :track_serial_nbr
      t.string :track_coo
      t.string :priority
      t.string :receiver_comments
      t.string :verifying_comments
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
    drop_table :asn_details
  end
end
