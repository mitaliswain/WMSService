# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140420030631) do

  create_table "asn_details", force: true do |t|
    t.string   "client"
    t.string   "warehouse"
    t.string   "channel"
    t.string   "building"
    t.integer  "asn_header_id"
    t.string   "type"
    t.string   "purchase_order_nbr"
    t.integer  "poline_nbr"
    t.string   "shipment_nbr"
    t.integer  "sequence"
    t.string   "hot_item"
    t.string   "item"
    t.string   "sku_attribute1"
    t.string   "sku_attribute2"
    t.string   "sku_attribute3"
    t.string   "sku_attribute4"
    t.string   "sku_attribute5"
    t.string   "sku_attribute6"
    t.string   "sku_attribute7"
    t.string   "sku_attribute8"
    t.string   "sku_attribute9"
    t.string   "sku_attribute10"
    t.string   "concept"
    t.string   "description"
    t.string   "short_desc"
    t.string   "barcode"
    t.string   "inventory_type"
    t.string   "vendor_factory"
    t.string   "coo"
    t.integer  "innerpack_qty"
    t.integer  "standardcase_qty"
    t.integer  "po_qty"
    t.integer  "received_qty"
    t.integer  "verified_qty"
    t.integer  "cases_rcvd"
    t.integer  "cases_verified"
    t.integer  "unit_cost"
    t.integer  "landing_cost"
    t.integer  "retail_price"
    t.string   "uom"
    t.integer  "unit_wgt"
    t.string   "track_lotcontrol"
    t.string   "track_serial_nbr"
    t.string   "track_coo"
    t.string   "priority"
    t.string   "receiver_comments"
    t.string   "verifying_comments"
    t.string   "record_status"
    t.string   "attribute1"
    t.string   "attribute2"
    t.string   "attribute3"
    t.string   "attribute4"
    t.string   "attribute5"
    t.string   "attribute6"
    t.string   "attribute7"
    t.string   "attribute8"
    t.string   "attribute9"
    t.string   "attribute10"
    t.string   "attribute11"
    t.string   "attribute12"
    t.string   "attribute13"
    t.string   "attribute14"
    t.string   "attribute15"
    t.string   "attribute16"
    t.string   "attribute17"
    t.string   "attribute18"
    t.string   "attribute19"
    t.string   "attribute20"
    t.string   "attribute21"
    t.string   "attribute22"
    t.string   "attribute23"
    t.string   "attribute24"
    t.string   "attribute25"
    t.datetime "created_date"
    t.string   "created_user"
    t.string   "created_prc"
    t.datetime "update_date"
    t.string   "updated_user"
    t.string   "updated_prc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "asn_headers", force: true do |t|
    t.string   "client"
    t.string   "warehouse"
    t.string   "channel"
    t.string   "building"
    t.string   "type"
    t.string   "purchase_order_nbr"
    t.string   "shipment_nbr"
    t.string   "source"
    t.string   "source_comment"
    t.string   "appointment_nbr"
    t.string   "hot_item_po"
    t.string   "ship_form"
    t.string   "ship_to"
    t.string   "vendor_nbr"
    t.string   "vendor_factory"
    t.string   "coo"
    t.string   "track_lotcontrol"
    t.string   "track_serial_nbr"
    t.string   "track_coo"
    t.string   "trailor_type"
    t.string   "ship_via"
    t.string   "manifest_nbr"
    t.string   "bol"
    t.string   "seal_nbr"
    t.string   "scac_code"
    t.string   "order_nbr"
    t.string   "order_type"
    t.string   "buyer_id"
    t.string   "buyer_name"
    t.string   "department"
    t.string   "buyer_email_id"
    t.string   "vendor_contact"
    t.string   "vendor_name"
    t.string   "phone"
    t.string   "vendor_email_id"
    t.string   "fax_nbr"
    t.integer  "total_units"
    t.integer  "total_weight"
    t.integer  "total_volume"
    t.integer  "carier_charges"
    t.string   "carierformats"
    t.integer  "cases_ordered"
    t.integer  "unit_ordered"
    t.integer  "cases_rcvd"
    t.integer  "units_rcvd"
    t.datetime "po_created_date"
    t.string   "pocreated_by"
    t.datetime "po_last_modified_date"
    t.string   "po_last_modified_by"
    t.datetime "po_downloaded_date"
    t.string   "po_downloaded_by"
    t.datetime "po_cancelled_date"
    t.string   "po_cancelled_by"
    t.string   "auto_cancel_po"
    t.datetime "cancel_bydate"
    t.integer  "cancel_after_days"
    t.datetime "po_ship_date"
    t.string   "mode_of_transport"
    t.datetime "receiving_started_date"
    t.string   "receiving_started_by"
    t.string   "door_door"
    t.string   "area"
    t.datetime "receiving_ended_date"
    t.string   "receiving_ended_by"
    t.datetime "first_recieving_date"
    t.string   "first_recieving_by"
    t.string   "first_recieve_dock_door"
    t.string   "shipment_verified"
    t.datetime "shipment_verified_date"
    t.string   "shipment_verified_by"
    t.string   "comments"
    t.string   "hold_inventory"
    t.string   "hold_code"
    t.string   "alert_buyer"
    t.string   "override_qa_plan"
    t.string   "overided_plan"
    t.string   "record_status"
    t.string   "attribute1"
    t.string   "attribute2"
    t.string   "attribute3"
    t.string   "attribute4"
    t.string   "attribute5"
    t.string   "attribute6"
    t.string   "attribute7"
    t.string   "attribute8"
    t.string   "attribute9"
    t.string   "attribute10"
    t.string   "attribute11"
    t.string   "attribute12"
    t.string   "attribute13"
    t.string   "attribute14"
    t.string   "attribute15"
    t.string   "attribute16"
    t.string   "attribute17"
    t.string   "attribute18"
    t.string   "attribute19"
    t.string   "attribute20"
    t.string   "attribute21"
    t.string   "attribute22"
    t.string   "attribute23"
    t.string   "attribute24"
    t.string   "attribute25"
    t.string   "attribute26"
    t.string   "attribute27"
    t.string   "attribute28"
    t.string   "attribute29"
    t.string   "attribute30"
    t.datetime "created_date"
    t.string   "created_user"
    t.string   "created_prc"
    t.datetime "update_date"
    t.string   "updated_user"
    t.string   "updated_prc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
