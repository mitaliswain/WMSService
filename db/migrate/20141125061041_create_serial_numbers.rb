class CreateSerialNumbers < ActiveRecord::Migration
  def change
    create_table :serial_numbers do |t|
      t.string :client
      t.string :warehouse
      t.string :channel
      t.string :building
      t.string :case_id
      t.string :serial_nbr
      t.string :purchase_order_nbr
      t.integer :poline_nbr
      t.string :lot_nbr
      t.string :shipment_nbr
      t.string :item_barcode
      t.string :vendor_nbr
      t.string :vendor_factory
      t.string :coo
      t.string :order_nbr
      t.string :order_type
      t.string :carton_nbr
      t.integer :total_units
      t.string :comments
      t.string :status
      t.string :hold_code
      t.string :record_status
      t.datetime :created_date
      t.string :created_user
      t.string :created_prc
      t.datetime :update_date
      t.string :updated_user
      t.string :updated_prc

      t.timestamps
    end
  end
end
