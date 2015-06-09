class CreateVendorMasters < ActiveRecord::Migration
  def change
    create_table :vendor_masters do |t|
      t.string :client
      t.string :warehouse
      t.string :channel
      t.string :building
      t.string :vendor_nbr
      t.string :type
      t.string :vendor_name
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :city
      t.string :state
      t.integer :zip
      t.string :contact
      t.integer :contact_phone
      t.string :contact_email
      t.string :primary_factory
      t.string :tolerance_pct
      t.integer :po_rcv_tolerance
      t.integer :poline_rcv_tolerance
      t.integer :shipment_tolerance
      t.integer :override_tolerance
      t.integer :vasn_tolerance_pct
      t.integer :vasn_tolerance_pct
      t.integer :vasn_line_rcv_tolerance
      t.integer :vasn_shipment_tolerance
      t.integer :vasn_override_tolerance
      t.integer :qa_pct
      t.string :qa_group
      t.string :qa_rule
      t.string :rtv_contact
      t.string :rtv_name
      t.string :rtv_address1
      t.string :rtv_address2
      t.string :rtv_address3
      t.string :rtv_city
      t.string :rtv_state
      t.string :rtv_country
      t.string :return_asn_reqd
      t.string :communication
      t.string :rtv_email_address
      t.string :auto_crt_rtv
      t.string :carrier1
      t.string :Carrier_service1
      t.string :carrier2
      t.string :service2
      t.string :carrier3
      t.string :service3
      t.string :carrier4
      t.string :service4
      t.string :status
      t.datetime :created_date
      t.string :created_by
      t.string :created_proc
      t.datetime :update_date
      t.string :updated_by
      t.string :updated_proc

      t.timestamps
    end
  end
  def down
    drop_table :vendor_masters
  end
end
