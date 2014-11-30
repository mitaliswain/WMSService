module Shipment
require 'utilities/utility'
require 'utilities/response'

include Utility
include Response

module ShipmentMaintenanceDetail
      extend ActiveSupport::Concern
        
  def update_shipment_detail(app_parameters, id, fields_to_update)
       input_obj = app_parameters.merge(fields_to_update).merge(id: id).to_hash
       if valid_app_parameters?(input_obj) && 
         valid_data?(input_obj)
         
         shipment_hash = AsnDetail.find(id)   
         fields_to_update.each do |field, data|
            shipment_hash.attributes =  {field => data} 
         end   
         shipment_hash.save!
         resource_updated_successfully("Shipment Detail #{id}") 
        end  
        message   
  end
  
  
  def add_shipment_detail(app_parameters, fields_to_add)
       input_obj = app_parameters.merge(fields_to_add).to_hash
       if valid_input?(input_obj) 
          shipment_hash = AsnDetail.new(input_obj)  
          shipment_hash = add_shipment_detail_derived_data(shipment_hash.clone)
          shipment_hash.save!    
          resource_added_successfully("Shipment #{shipment_hash.id}", "/shipment/#{shipment_hash.asn_header_id}/detail/#{shipment_hash.id}")
       end        
       message  
  end 
  
  def valid_input?(input_obj)      
      (valid_app_parameters?(input_obj) && 
       valid_mandatory_fields?(input_obj) &&
       valid_data?(input_obj))  ? true : false    
  end
  
  def add_shipment_detail_derived_data(asn_detail_clone)
    asn_detail = asn_detail_clone
    asn_header = AsnHeader.find(asn_detail.asn_header_id)
    asn_detail.shipment_nbr = asn_header.shipment_nbr
    asn_detail.purchase_order_nbr = asn_header.purchase_order_nbr
    asn_detail.vendor_factory = asn_header.vendor_factory
    asn_detail.coo = asn_header.coo
    asn_detail.asn_type = asn_header.asn_type
    asn_detail.sequence = get_next_sequence(asn_detail.clone)
    asn_detail.poline_nbr = asn_detail.sequence
    asn_detail.description = @item_master.description
    asn_detail.short_desc = @item_master.short_desc
    asn_detail.barcode = @item_master.barcode
    asn_detail.inventory_type = @item_master.inventory_type
    asn_detail.unit_cost = @item_master.unit_cost
    #asn_detail.landing_cost = @item_master.landing_cost
    asn_detail.retail_price = @item_master.retail_price
    asn_detail.uom = @item_master.uom
    asn_detail.unit_wgt = @item_master.unit_wgt
    #asn_detail.unit_vol = @item_master.unit_vol
    asn_detail
  end
  
  
  def get_next_sequence(shipment_hash)
    shipment_detail = AsnDetail.where(client: shipment_hash.client, shipment_nbr: shipment_hash.shipment_nbr).order(:sequence).last
    shipment_detail.nil? ? 1: shipment_detail.sequence.to_i + 1
  end
  
  def valid_data?(fields_to_update)
    is_valid = true
    fields_to_update.each do |field, value|
        method ="valid_#{field.to_s}?"
        is_valid = (respond_to?(method) ? send(method, fields_to_update) : true)  && is_valid                 
    end   
    is_valid
   
  end 
  
  def valid_mandatory_fields?(fields_to_update)
    is_valid = true
    is_valid = valid_asn_header_id?(fields_to_update) && is_valid 
    is_valid = valid_item?(fields_to_update) && is_valid 
     
    is_valid   
  end 

  
   def valid_asn_header_id?(fields_to_update)
     if !fields_to_update.symbolize_keys.has_key?(:asn_header_id)
       validation_failed('422', :asn_header_id, 'Asn Header ID is blank')
     else
       true
    end
  end  
  
  def valid_hot_item?(fields_to_update)
    
     if fields_to_update.hot_item != "Y" &&  fields_to_update.hot_item != "N"
       validation_failed('422', :hot_item, 'Invalid Hot Item')
     else
       true
    end
  end  
  
  def valid_item?(fields_to_update) 
    case     
     when !fields_to_update.symbolize_keys.has_key?(:item)
       validation_failed('422', :item, 'Please enter the item')
       
     when !fields_to_update.item.present?
       validation_failed('422', :item, 'Item can not be nill or blank!')
     else
        @item_master = ItemMaster.where(client: fields_to_update.client, item: fields_to_update.item).first                      
        @item_master.nil? ? validation_failed('422', :item, 'Item not in item master') : true
    end
  end
  
  def valid_track_lot_control?(fields_to_update)
    if fields_to_update.track_lotcontrol != "Y" &&  fields_to_update.track_lotcontrol != "N"
       validation_failed('422', :track_lotcontrol, 'Invalid lot control')
     else
       true
    end
  end
   
  def valid_track_serial_nbr?(fields_to_update)
    if fields_to_update.track_serial_nbr != "Y" &&  fields_to_update.track_serial_nbr != "N"
       validation_failed('422', :track_serial_nbr, 'Invalid Serial Number')
     else
       true
    end
  end 
  
   def valid_track_coo?(fields_to_update)
    if fields_to_update.track_coo != "Y" &&  fields_to_update.track_coo != "N"
       validation_failed('422', :track_coo, 'Invalid Country of origins')
     else
       true
    end
  end 
  
  def valid_priority?(fields_to_update)
    if fields_to_update.priority != "Y" &&  fields_to_update.priority != "N"
       validation_failed('422', :priority, 'Invalid Priority')
     else
       true
    end
  end 
end 

end