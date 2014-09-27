include Utility
include Response

class AsnDetail < ActiveRecord::Base
  attr_accessor :message
  validates_uniqueness_of :sequence, scope: [:client, :shipment_nbr]
  validates_presence_of  :client, :warehouse, :shipment_nbr, :sequence, :item, :asn_header_id
  validates_presence_of  :building, :channel,  :allow_nil => true
  
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
       input_obj = app_parameters.merge(fields_to_add).merge(id: id).to_hash
       if valid_app_parameters?(input_obj) && 
          valid_mandatory_fields?(input_obj) &&
          valid_data?(input_obj)    
          shipment_hash = AsnDetail.new(input_obj)  
          shipment_hash = add_derived_data(shipment_hash.clone)
         

         shipment_hash.save!    
         
         resource_added_successfully("Shipment #{id}", "/shipment/#{shipment_hash.id}")                 
       end        
       message  
  end 
  
  def add_derived_data(asn_detail_clone)
    asn_detail = asn_detail_clone
    asn_detail.shipment_nbr = AsnHeader.find(asn_detail.asn_header_id).shipment_nbr
    asn_detail.sequence = get_next_sequence(asn_detail.clone)
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
     
    is_valid   
  end 

  
   def valid_asn_header_id?(fields_to_update)
   
     if fields_to_update.has_key?('asn_header_id')
       validation_failed('422', :asn_header_id, 'Asn Header ID is blank')
     else
       true
    end
  end  
  
  def valid_item?(fields_to_update) 
     if fields_to_update.has_key?('item')
       validation_failed('422', :item, 'Please enter the item')
     else
        @item_master = ItemMaster.where(client: fields_to_update.client, item: fields_to_update.item).first                      
        @item_master.nil? ? validation_failed('422', :item, 'Item not in item master') : true
    end
  end
    
end
