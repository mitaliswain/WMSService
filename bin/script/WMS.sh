#rails g model asn_header   client:string warehouse:string channel:string building:string type:string purchase_order_nbr:string shipment_nbr:string source:string source_comment:string appointment_nbr:string hot_item_po:string ship_form:string ship_to:string vendor_nbr:string vendor_factory:string coo:string track_lotcontrol:string track_serial_nbr:string track_coo:string trailor_type:string ship_via:string manifest_nbr:string bol:string seal_nbr:string scac_code:string order_nbr:string order_type:string buyer_id:string buyer_name:string department:string buyer_email_id:string vendor_contact:string vendor_name:string phone:string vendor_email_id:string fax_nbr:string total_units:integer total_weight:integer total_volume:integer carier_charges:integer carierformats:string cases_ordered:integer unit_ordered:integer cases_rcvd:integer units_rcvd:integer po_created_date:datetime pocreated_by:string po_last_modified_date:datetime po_last_modified_by:string po_downloaded_date:datetime po_downloaded_by:string po_cancelled_date:datetime po_cancelled_by:string auto_cancel_po:string cancel_bydate:datetime cancel_after_days:integer po_ship_date:datetime mode_of_transport:string receiving_started_date:datetime receiving_started_by:string door_door:string area:string receiving_ended_date:datetime receiving_ended_by:string first_recieving_date:datetime first_recieving_by:string first_recieve_dock_door:string area:string shipment_verified:string shipment_verified_date:datetime shipment_verified_by:string comments:string hold_inventory:string hold_code:string alert_buyer:string override_qa_plan:string overided_plan:string record_status:string attribute1:string attribute2:string attribute3:string attribute4:string attribute5:string attribute6:string attribute7:string attribute8:string attribute9:string attribute10:string attribute11:string attribute12:string attribute13:string attribute14:string attribute15:string attribute16:string attribute17:string attribute18:string attribute19:string attribute20:string attribute21:string attribute22:string attribute23:string attribute24:string attribute25:string attribute26:string attribute27:string attribute28:string attribute29:string attribute30:string created_date:datetime created_user:string created_prc:string update_date:datetime updated_user:string updated_prc:string
#rails g model asn_detail client:string warehouse:string channel:string building:string asn_header_id:integer type:string purchase_order_nbr:string poline_nbr:integer shipment_nbr:string sequence:integer hot_item:string item:string sku_attribute1:string sku_attribute2:string sku_attribute3:string sku_attribute4:string sku_attribute5:string sku_attribute6:string sku_attribute7:string sku_attribute8:string sku_attribute9:string sku_attribute10:string concept:string description:string short_desc:string barcode:string inventory_type:string vendor_factory:string coo:string innerpack_qty:integer standardcase_qty:integer po_qty:integer received_qty:integer verified_qty:integer cases_rcvd:integer cases_verified:integer unit_cost:integer landing_cost:integer retail_price:integer uom:string unit_wgt:integer track_lotcontrol:string track_serial_nbr:string track_coo:string priority:string receiver_comments:string verifying_comments:string record_status:string attribute1:string attribute2:string attribute3:string attribute4:string attribute5:string attribute6:string attribute7:string attribute8:string attribute9:string attribute10:string attribute11:string attribute12:string attribute13:string attribute14:string attribute15:string attribute16:string attribute17:string attribute18:string attribute19:string attribute20:string attribute21:string attribute22:string attribute23:string attribute24:string attribute25:string created_date:datetime created_user:string created_prc:string update_date:datetime updated_user:string updated_prc:string
#rails g model case_header client:string warehouse:string channel:string building:string case_id:string pallet_id:string status:string item:string sku_attribute1:string sku_attribute2:string sku_attribute3:string sku_attribute4:string sku_attribute5:string sku_attribute6:string sku_attribute7:string sku_attribute8:string sku_attribute9:string sku_attribute10:string concept:string description:string short_desc:string barcode:string inventory_type:string Location_type:string area:string zone:string aisle:string bay:string level:string position:string previous_locn_type:string previous_area:string previous_zone:string previous_aisle:string previous_bay:string previous_level:string previous_position:string quantity:integer allocated_qty:integer purchase_order_nbr:string poline_nbr:integer shipment_nbr:string sequence:integer appointment_nbr:string vendor_nbr:string vendor_factory:string coo:string track_lotcontrol:string track_serial_nbr:string track_coo:string climate_control:string order_type:string order_nbr:string allocation_type:string allocation_nbr:string pick_type:string pick_nbr:string total_weight:integer total_volume:integer case_type:string case_len:integer cases_wdt:integer case_hgt:integer multi_sku:string conveyable:string inner_pack_qty:integer case_pack_qty:integer perishble:string special_handling:string qa_auditted:string audit_nbr:string priority_type:string priority_nbr:string task_type:string task_nbr:string wave_type:string wave_nbr:string split_case:string parent_case_id:string lable_type:string transfer:string transfer_from:string form_co:string from_div:string transfer_to:string to_co:string to_div:string cross_dock:string received_date:datetime received_by:string case_verified:string verified_date:datetime verified_by:string comments:string on_hold:string hold_code:string record_status:string attribute1:string attribute2:string attribute3:string attribute4:string attribute5:string attribute6:string attribute7:string attribute8:string attribute9:string attribute10:string attribute11:string attribute12:string attribute13:string attribute14:string attribute15:string attribute16:string attribute17:string attribute18:string attribute19:string attribute20:string attribute21:string attribute22:string attribute23:string attribute24:string attribute25:string created_date:datetime created_user:string created_prc:string update_date:datetime updated_user:string updated_prc:string
#rails g model case_detail client:string warehouse:string channel:string building:string case_header_id:integer case_id:string sequence:integer pallet_id:string status:string item:string sku_attribute1:string sku_attribute2:string sku_attribute3:string sku_attribute4:string sku_attribute5:string sku_attribute6:string sku_attribute7:string sku_attribute8:string sku_attribute9:string sku_attribute10:string concept:string description:string short_desc:string barcode:string inventory_type:string quantity:integer allocated_qty:integer purchase_order_nbr:string poline_nbr:integer shipment_nbr:string shipment_line_nbr:integer vendor_nbr:string vendor_factory:string coo:string lot_control_nbr:string serial_nbr:string unit_weight:integer unit_volume:integer record_status:string attribute1:string attribute2:string attribute3:string attribute4:string attribute5:string attribute6:string attribute7:string attribute8:string attribute9:string attribute10:string attribute11:string attribute12:string attribute13:string attribute14:string attribute15:string attribute16:string attribute17:string attribute18:string attribute19:string attribute20:string attribute21:string attribute22:string attribute23:string attribute24:string attribute25:string created_date:datetime created_user:string created_prc:string update_date:datetime updated_user:string updated_prc:string
#rails g model location_master client:string warehouse:string channel:string building:string location_type:string area:string zone:string aisle:string bay:string level:string position:string barcode:string climate_control:string minimum_temp:string maximum_temp:string lot_control_only:string serial_nbr_only:string single_sku_locn:string dedicated_sku_locn:string defalt_putaway_type:string secured_locn_type:string maximum_wgt:integer length:integer height:integer width:integer volume:integer preffered_pallet_type:string maximum_pallets:integer preffered_case_type:string maximum_cases:integer minimum_units:integer maximum_units:integer combine_locn:string equipment_type:string record_status:string attribute1:string attribute2:string attribute3:string attribute4:string attribute5:string attribute6:string attribute7:string attribute8:string attribute9:string attribute10:string attribute11:string attribute12:string attribute13:string attribute14:string attribute15:string attribute16:string attribute17:string attribute18:string attribute19:string attribute20:string attribute21:string attribute22:string attribute23:string attribute24:string attribute25:string created_date:datetime created_user:string created_prc:string update_date:datetime updated_user:string updated_prc:string
#rails g model global_configuration client:string warehouse:string channel:string building:string sequence_no:integer module:string module_description:string submodule1:string submodule2:string submodule3:string submodule4:string submodule5:string user:string user_role:string app_id:integer key:string value:string attribute1:string attribute2:string attribute3:string attribute4:string attribute5:string attribute6:string attribute7:string attribute8:string attribute9:string attribute10:string enable:boolean created_date:datetime created_user:string created_prc:string update_date:datetime updated_user:string updated_prc:string
#rails g model item_master client:string warehouse:string channel:string building:string item:string sku_attribute1:string sku_attribute2:string sku_attribute3:string sku_attribute4:string sku_attribute5:string sku_attribute6:string sku_attribute7:string sku_attribute8:string sku_attribute9:string sku_attribute10:string sku_attribute11:string sku_attribute12:string sku_attribute13:string sku_attribute14:string sku_attribute15:string sku_attribute16:string sku_attribute17:string sku_attribute18:string sku_attribute19:string sku_attribute20:string sku_attribute21:string sku_attribute22:string sku_attribute23:string sku_attribute24:string sku_attribute25:string sku_attribute26:string sku_attribute27:string sku_attribute28:string sku_attribute29:string sku_attribute30:string concept:string description:string short_desc:string barcode:string unit_putaway_type:string sku_location_type:string case_putaway_type:string pallet_putaway_type:string suggested_zone:string suggested_act_zone:string active_locn_cnt_factor:string reserve_locn_cnt_factor:string wave_proc_type:string uom:string selling_uom:string stocking_uom:string track_lotcontrol:string track_serial_nbr:string track_coo:string pallet_type:string carton_type:string carton_brk_attr:string coo:string multiple_coo:string volatility_code:string inner_pack_qty:integer box_qty:integer standard_case_qty:integer case_len:decimal case_wdt:decimal case_depth:decimal max_cases_stacked:integer no_ofcases_per_pallet:integer pallet_qty:integer coveyable:string quantity_audit_per:integer minimum_act_inv:integer maximum_act_inv:integer date_sensitivity:string product_temp_zone:string trailer_temp_zone:string haz_code:string hts_code:string nmfc_code:string topself_eligible:string crushablity_code:string inner_ctn_type:string stackbility_of_items:string goh:string track_cases_in_act:string product_life_inshelf:integer ship_alone:string case_consume_pty:string unit_len:decimal unit_hgt:decimal unit_wdt:decimal unit_wgt:decimal unit_vol:decimal cavity_len:decimal cavity_wdt:decimal cavity_hgtt:decimal maximum_nest:decimal vendor_nbr:string inventory_type:string status:string department:string average_wgt_cost:decimal unit_cost:decimal retail_price:decimal special_inst1:string special_inst2:string special_inst3:string special_inst4:string special_inst5:string special_inst6:string special_inst7:string special_inst8:string special_inst9:string special_inst10:string created_date:datetime created_user:string created_prc:string update_date:datetime updated_user:string updated_prc:string
#rails g model item_inner_pack client:string warehouse:string channel:string building:string item:string sku_attribute1:string sku_attribute2:string sku_attribute3:string sku_attribute4:string sku_attribute5:string sku_attribute6:string sku_attribute7:string sku_attribute8:string sku_attribute9:string sku_attribute10:string sku_attribute11:string sku_attribute12:string sku_attribute13:string sku_attribute14:string sku_attribute15:string sku_attribute16:string sku_attribute17:string sku_attribute18:string sku_attribute19:string sku_attribute20:string sku_attribute21:string sku_attribute22:string sku_attribute23:string sku_attribute24:string sku_attribute25:string concept:string description:string short_desc:string barcode:string innerpack_code:string innerpack_qty:integer innerpack_wgt:decimal innerpack_vol:decimal innerpack_len:decimal innerpack_wdt:decimal innerpack_hgt:decimal hold_inventory:string hold_type:string status:string created_date:datetime created_user:string created_prc:string update_date:datetime updated_user:string updated_prc:string pickslip_nbr:string
#rails g migration AddShippedQuantityToAsnDetails shipped_quantity:integer
#rails g model message client:string message_id:string message_description:string message_type:string message_severity:integer attribute1:string attribute2:string attribute3:string attribute4:string attribute5:string attribute6:string attribute7:string attribute8:string attribute9:string attribute10:string update_date:datetime updated_user:string updated_prc:string
#rails g migration RemoveFieldFromCaseHeader item:string
#rails g migration  AddFieldToCaseHeader from_channel:string from_building:string to_channel:string to_building:string
#rails g migration RemoveFieldFromCaseDetail pallet_id:string status:string inventory_type:string shipment_nbr:string shipment_line_nbr:integer vendor_nbr:string vendor_factory:string coo:string lot_control_nbr:string serial_nbr:string
rails g model serial_number client:string warehouse:string channel:string building:string case_id:string serial_nbr:string purchase_order_nbr:string poline_nbr:integer lot_nbr:string shipment_nbr:string item_barcode:string vendor_nbr:string vendor_factory:string coo:string order_nbr:string order_type:string carton_nbr:string total_units:integer comments:string status:string hold_code:string record_status:string created_date:datetime created_user:string created_prc:string update_date:datetime updated_user:string updated_prc:string