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

ActiveRecord::Schema.define(version: 20151024194652) do

  create_table "asn_details", force: true do |t|
    t.string   "client"
    t.string   "warehouse"
    t.string   "channel"
    t.string   "building"
    t.integer  "asn_header_id"
    t.string   "asn_type"
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
    t.decimal  "unit_cost"
    t.decimal  "landing_cost"
    t.decimal  "retail_price"
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
    t.integer  "shipped_quantity"
  end

  create_table "asn_headers", force: true do |t|
    t.string   "client"
    t.string   "warehouse"
    t.string   "channel"
    t.string   "building"
    t.string   "asn_type"
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

  create_table "case_details", force: true do |t|
    t.string   "client"
    t.string   "warehouse"
    t.string   "channel"
    t.string   "building"
    t.integer  "case_header_id"
    t.string   "case_id"
    t.integer  "sequence"
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
    t.integer  "quantity"
    t.integer  "allocated_qty"
    t.string   "purchase_order_nbr"
    t.integer  "poline_nbr"
    t.integer  "unit_weight"
    t.integer  "unit_volume"
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

  create_table "case_headers", force: true do |t|
    t.string   "client"
    t.string   "warehouse"
    t.string   "channel"
    t.string   "building"
    t.string   "case_id"
    t.string   "pallet_id"
    t.string   "status"
    t.string   "inventory_type"
    t.string   "previous_locn_type"
    t.integer  "quantity"
    t.integer  "allocated_qty"
    t.string   "purchase_order_nbr"
    t.integer  "poline_nbr"
    t.string   "shipment_nbr"
    t.integer  "sequence"
    t.string   "appointment_nbr"
    t.string   "vendor_nbr"
    t.string   "vendor_factory"
    t.string   "coo"
    t.string   "track_lotcontrol"
    t.string   "track_serial_nbr"
    t.string   "track_coo"
    t.string   "climate_control"
    t.string   "order_type"
    t.string   "order_nbr"
    t.string   "allocation_type"
    t.string   "allocation_nbr"
    t.string   "pick_type"
    t.string   "pick_nbr"
    t.integer  "total_weight"
    t.integer  "total_volume"
    t.string   "case_type"
    t.integer  "case_len"
    t.integer  "cases_wdt"
    t.integer  "case_hgt"
    t.string   "multi_sku"
    t.string   "conveyable"
    t.integer  "inner_pack_qty"
    t.integer  "case_pack_qty"
    t.string   "perishble"
    t.string   "special_handling"
    t.string   "qa_auditted"
    t.string   "audit_nbr"
    t.string   "priority_type"
    t.string   "priority_nbr"
    t.string   "task_type"
    t.string   "task_nbr"
    t.string   "wave_type"
    t.string   "wave_nbr"
    t.string   "split_case"
    t.string   "parent_case_id"
    t.string   "lable_type"
    t.string   "transfer"
    t.string   "transfer_from"
    t.string   "form_co"
    t.string   "transfer_to"
    t.string   "cross_dock"
    t.datetime "received_date"
    t.string   "received_by"
    t.string   "case_verified"
    t.datetime "verified_date"
    t.string   "verified_by"
    t.string   "comments"
    t.string   "on_hold"
    t.string   "hold_code"
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
    t.string   "from_channel"
    t.string   "from_building"
    t.string   "to_channel"
    t.string   "to_building"
    t.string   "location"
    t.string   "previous_location"
    t.string   "location_type"
  end

  create_table "global_configurations", force: true do |t|
    t.string   "client"
    t.string   "warehouse"
    t.string   "channel"
    t.string   "building"
    t.integer  "sequence_no"
    t.string   "module"
    t.string   "module_description"
    t.string   "submodule1"
    t.string   "submodule2"
    t.string   "submodule3"
    t.string   "submodule4"
    t.string   "submodule5"
    t.string   "user"
    t.string   "user_role"
    t.integer  "app_id"
    t.string   "key"
    t.string   "value"
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
    t.boolean  "enable"
    t.datetime "created_date"
    t.string   "created_user"
    t.string   "created_prc"
    t.datetime "update_date"
    t.string   "updated_user"
    t.string   "updated_prc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_inner_packs", force: true do |t|
    t.string   "client"
    t.string   "warehouse"
    t.string   "channel"
    t.string   "building"
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
    t.string   "sku_attribute11"
    t.string   "sku_attribute12"
    t.string   "sku_attribute13"
    t.string   "sku_attribute14"
    t.string   "sku_attribute15"
    t.string   "sku_attribute16"
    t.string   "sku_attribute17"
    t.string   "sku_attribute18"
    t.string   "sku_attribute19"
    t.string   "sku_attribute20"
    t.string   "sku_attribute21"
    t.string   "sku_attribute22"
    t.string   "sku_attribute23"
    t.string   "sku_attribute24"
    t.string   "sku_attribute25"
    t.string   "concept"
    t.string   "description"
    t.string   "short_desc"
    t.string   "barcode"
    t.string   "innerpack_code"
    t.integer  "innerpack_qty"
    t.decimal  "innerpack_wgt"
    t.decimal  "innerpack_vol"
    t.decimal  "innerpack_len"
    t.decimal  "innerpack_wdt"
    t.decimal  "innerpack_hgt"
    t.string   "hold_inventory"
    t.string   "hold_type"
    t.string   "status"
    t.datetime "created_date"
    t.string   "created_user"
    t.string   "created_prc"
    t.datetime "update_date"
    t.string   "updated_user"
    t.string   "updated_prc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_masters", force: true do |t|
    t.string   "client"
    t.string   "warehouse"
    t.string   "channel"
    t.string   "building"
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
    t.string   "sku_attribute11"
    t.string   "sku_attribute12"
    t.string   "sku_attribute13"
    t.string   "sku_attribute14"
    t.string   "sku_attribute15"
    t.string   "sku_attribute16"
    t.string   "sku_attribute17"
    t.string   "sku_attribute18"
    t.string   "sku_attribute19"
    t.string   "sku_attribute20"
    t.string   "sku_attribute21"
    t.string   "sku_attribute22"
    t.string   "sku_attribute23"
    t.string   "sku_attribute24"
    t.string   "sku_attribute25"
    t.string   "sku_attribute26"
    t.string   "sku_attribute27"
    t.string   "sku_attribute28"
    t.string   "sku_attribute29"
    t.string   "sku_attribute30"
    t.string   "concept"
    t.string   "description"
    t.string   "short_desc"
    t.string   "barcode"
    t.string   "unit_putaway_type"
    t.string   "sku_location_type"
    t.string   "case_putaway_type"
    t.string   "pallet_putaway_type"
    t.string   "suggested_zone"
    t.string   "suggested_act_zone"
    t.string   "active_locn_cnt_factor"
    t.string   "reserve_locn_cnt_factor"
    t.string   "wave_proc_type"
    t.string   "uom"
    t.string   "selling_uom"
    t.string   "stocking_uom"
    t.string   "track_lotcontrol"
    t.string   "track_serial_nbr"
    t.string   "track_coo"
    t.string   "pallet_type"
    t.string   "carton_type"
    t.string   "carton_brk_attr"
    t.string   "coo"
    t.string   "multiple_coo"
    t.string   "volatility_code"
    t.integer  "inner_pack_qty"
    t.integer  "box_qty"
    t.integer  "standard_case_qty"
    t.decimal  "case_len"
    t.decimal  "case_wdt"
    t.decimal  "case_depth"
    t.integer  "max_cases_stacked"
    t.integer  "no_ofcases_per_pallet"
    t.integer  "pallet_qty"
    t.string   "coveyable"
    t.integer  "quantity_audit_per"
    t.integer  "minimum_act_inv"
    t.integer  "maximum_act_inv"
    t.string   "date_sensitivity"
    t.string   "product_temp_zone"
    t.string   "trailer_temp_zone"
    t.string   "haz_code"
    t.string   "hts_code"
    t.string   "nmfc_code"
    t.string   "topself_eligible"
    t.string   "crushablity_code"
    t.string   "inner_ctn_type"
    t.string   "stackbility_of_items"
    t.string   "goh"
    t.string   "track_cases_in_act"
    t.integer  "product_life_inshelf"
    t.string   "ship_alone"
    t.string   "case_consume_pty"
    t.decimal  "unit_len"
    t.decimal  "unit_hgt"
    t.decimal  "unit_wdt"
    t.decimal  "unit_wgt"
    t.decimal  "unit_vol"
    t.decimal  "cavity_len"
    t.decimal  "cavity_wdt"
    t.decimal  "cavity_hgtt"
    t.decimal  "maximum_nest"
    t.string   "vendor_nbr"
    t.string   "inventory_type"
    t.string   "status"
    t.string   "department"
    t.decimal  "average_wgt_cost"
    t.decimal  "unit_cost"
    t.decimal  "retail_price"
    t.string   "special_inst1"
    t.string   "special_inst2"
    t.string   "special_inst3"
    t.string   "special_inst4"
    t.string   "special_inst5"
    t.string   "special_inst6"
    t.string   "special_inst7"
    t.string   "special_inst8"
    t.string   "special_inst9"
    t.string   "special_inst10"
    t.datetime "created_date"
    t.string   "created_user"
    t.string   "created_prc"
    t.datetime "update_date"
    t.string   "updated_user"
    t.string   "updated_prc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "location_inventories", force: true do |t|
    t.string   "client"
    t.string   "warehouse"
    t.string   "building"
    t.string   "channel"
    t.string   "Location_type"
    t.string   "area"
    t.string   "zone"
    t.string   "aisle"
    t.string   "bay"
    t.string   "level"
    t.string   "position"
    t.integer  "sequence"
    t.string   "barcode"
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
    t.string   "inventory_type"
    t.integer  "quantity"
    t.integer  "total_qty"
    t.integer  "allocated_qty"
    t.integer  "pending_repl_qty"
    t.integer  "maximum_cases"
    t.integer  "pending_repl_cases"
    t.integer  "minimum_units"
    t.integer  "maximum_units"
    t.string   "replenish_locn"
    t.string   "case_id"
    t.string   "lot_control_nbr"
    t.string   "serial_nbr"
    t.string   "coo"
    t.string   "order_nbr"
    t.string   "allocation_type"
    t.string   "allocation_nbr"
    t.string   "pick_type"
    t.string   "pick_nbr"
    t.string   "abc_code"
    t.string   "hold_type"
    t.string   "hold_code"
    t.string   "cycle_counted"
    t.datetime "cycle_counted_date"
    t.string   "cycle_counted_by"
    t.string   "discrepancies"
    t.string   "task_type"
    t.integer  "task_nbr"
    t.string   "climate_control"
    t.string   "minimum_temp"
    t.string   "maximum_temp"
    t.string   "lot_control_only"
    t.string   "multi_lot_location"
    t.string   "serial_nbr_only"
    t.string   "multi_coo_location"
    t.string   "single_sku_locn"
    t.string   "dedicated_sku_locn"
    t.string   "default_putaway_type"
    t.string   "secured_locn_type"
    t.integer  "maximum_wgt"
    t.integer  "length"
    t.integer  "height"
    t.integer  "width"
    t.integer  "volume"
    t.string   "preferred_pallet_type"
    t.integer  "maximum_pallets"
    t.string   "preferred_case_type"
    t.string   "combine_locn"
    t.string   "combine_seq"
    t.string   "equipment_type"
    t.string   "record_status"
    t.datetime "created_date"
    t.string   "created_user"
    t.string   "created_prc"
    t.datetime "update_date"
    t.string   "updated_user"
    t.string   "updated_prc"
    t.string   "comments"
    t.string   "on_hold"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "location_masters", force: true do |t|
    t.string   "client"
    t.string   "warehouse"
    t.string   "channel"
    t.string   "building"
    t.string   "location_type"
    t.string   "area"
    t.string   "zone"
    t.string   "aisle"
    t.string   "bay"
    t.string   "level"
    t.string   "position"
    t.string   "barcode"
    t.string   "climate_control"
    t.string   "minimum_temp"
    t.string   "maximum_temp"
    t.string   "lot_control_only"
    t.string   "serial_nbr_only"
    t.string   "single_sku_locn"
    t.string   "dedicated_sku_locn"
    t.string   "defalt_putaway_type"
    t.string   "secured_locn_type"
    t.integer  "maximum_wgt"
    t.integer  "length"
    t.integer  "height"
    t.integer  "width"
    t.integer  "volume"
    t.string   "preffered_pallet_type"
    t.integer  "maximum_pallets"
    t.string   "preffered_case_type"
    t.integer  "maximum_cases"
    t.integer  "minimum_units"
    t.integer  "maximum_units"
    t.string   "combine_locn"
    t.string   "equipment_type"
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

  create_table "location_types", force: true do |t|
    t.string   "client"
    t.string   "warehouse"
    t.string   "channel"
    t.string   "building"
    t.string   "location_type"
    t.string   "description"
    t.string   "notes"
    t.string   "climate_control"
    t.string   "minimum_temp"
    t.string   "maximum_temp"
    t.string   "lot_control_only"
    t.string   "serial_nbr_only"
    t.string   "single_sku_locn"
    t.string   "default_putaway_type"
    t.string   "secured_locn_type"
    t.integer  "maximum_wgt"
    t.integer  "maximum_len"
    t.integer  "maximum_hgt"
    t.integer  "maximum_wdt"
    t.datetime "created_date"
    t.string   "created_by"
    t.string   "created_prc"
    t.datetime "update_date"
    t.string   "updated_by"
    t.string   "updated_prc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.string   "client"
    t.string   "message_id"
    t.string   "message_description"
    t.string   "message_type"
    t.integer  "message_severity"
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
    t.datetime "update_date"
    t.string   "updated_user"
    t.string   "updated_prc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "serial_numbers", force: true do |t|
    t.string   "client"
    t.string   "warehouse"
    t.string   "channel"
    t.string   "building"
    t.string   "case_id"
    t.string   "serial_nbr"
    t.string   "purchase_order_nbr"
    t.integer  "poline_nbr"
    t.string   "lot_nbr"
    t.string   "shipment_nbr"
    t.string   "item_barcode"
    t.string   "vendor_nbr"
    t.string   "vendor_factory"
    t.string   "coo"
    t.string   "order_nbr"
    t.string   "order_type"
    t.string   "carton_nbr"
    t.integer  "total_units"
    t.string   "comments"
    t.string   "status"
    t.string   "hold_code"
    t.string   "record_status"
    t.datetime "created_date"
    t.string   "created_user"
    t.string   "created_prc"
    t.datetime "update_date"
    t.string   "updated_user"
    t.string   "updated_prc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_masters", force: true do |t|
    t.string   "client"
    t.string   "user_id"
    t.string   "password"
    t.string   "user_name"
    t.string   "preferred_warehouse"
    t.string   "preferred_landing_screen"
    t.string   "avatar_url"
    t.string   "authorized_warehouse"
    t.string   "authorized_action"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.datetime "last_login"
    t.datetime "created_date"
    t.string   "created_user"
    t.string   "created_prc"
    t.datetime "update_date"
    t.string   "updated_user"
    t.string   "updated_prc"
  end

  create_table "vendor_masters", force: true do |t|
    t.string   "client"
    t.string   "warehouse"
    t.string   "channel"
    t.string   "building"
    t.string   "vendor_nbr"
    t.string   "type"
    t.string   "vendor_name"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "city"
    t.string   "state"
    t.integer  "zip"
    t.string   "contact"
    t.integer  "contact_phone"
    t.string   "contact_email"
    t.string   "primary_factory"
    t.string   "tolerance_pct"
    t.integer  "po_rcv_tolerance"
    t.integer  "poline_rcv_tolerance"
    t.integer  "shipment_tolerance"
    t.integer  "override_tolerance"
    t.integer  "vasn_tolerance_pct"
    t.integer  "vasn_line_rcv_tolerance"
    t.integer  "vasn_shipment_tolerance"
    t.integer  "vasn_override_tolerance"
    t.integer  "qa_pct"
    t.string   "qa_group"
    t.string   "qa_rule"
    t.string   "rtv_contact"
    t.string   "rtv_name"
    t.string   "rtv_address1"
    t.string   "rtv_address2"
    t.string   "rtv_address3"
    t.string   "rtv_city"
    t.string   "rtv_state"
    t.string   "rtv_country"
    t.string   "return_asn_reqd"
    t.string   "communication"
    t.string   "rtv_email_address"
    t.string   "auto_crt_rtv"
    t.string   "carrier1"
    t.string   "Carrier_service1"
    t.string   "carrier2"
    t.string   "service2"
    t.string   "carrier3"
    t.string   "service3"
    t.string   "carrier4"
    t.string   "service4"
    t.string   "status"
    t.datetime "created_date"
    t.string   "created_by"
    t.string   "created_proc"
    t.datetime "update_date"
    t.string   "updated_by"
    t.string   "updated_proc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
