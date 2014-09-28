include Utility
include Response

class AsnHeader < ActiveRecord::Base
  attr_reader :message
  
  validates_uniqueness_of :shipment_nbr, scope: :client
  validates_presence_of  :client, :warehouse, :shipment_nbr
  validates_presence_of  :building, :channel,  :allow_nil => true
  before_validation :convert_blank_to_null_for_building_and_channel  
   
  def update_shipment_header(app_parameters, id, fields_to_update)
       input_obj = app_parameters.merge(fields_to_update).merge(id: id).to_hash
       if valid_app_parameters?(input_obj) && valid_data?(input_obj)
         shipment_hash = AsnHeader.find(id)   
         fields_to_update.each do |field, data|
            shipment_hash.attributes =  {field => data} 
         end   
         shipment_hash.save!
         resource_updated_successfully("Shipment #{id}") 
        end  
        message 
  end

  def add_shipment_header(app_parameters, fields_to_add)
       input_obj = app_parameters.merge(fields_to_add).merge(id: id).to_hash
       if valid_data?(input_obj) && valid_app_parameters?(input_obj)
         shipment_hash = AsnHeader.new 
         app_parameters.each do |field, data|
           shipment_hash.attributes = {field => data}
         end
         fields_to_add.each do |field, data|
            shipment_hash.attributes =  {field => data} 
         end   
         shipment_hash.save!    
         resource_added_successfully("Shipment #{id}", "/shipment/#{shipment_hash.id}")                 
       end        
       message  
  end

  
  def valid_data?(fields_to_update)
    is_valid = true
    fields_to_update.each do |field, value|
        method ="valid_#{field.to_s}?"
        is_valid = (respond_to?(method) ? send(method, fields_to_update) : true)  && is_valid                 
    end   
    is_valid
  end 
  
  def valid_asn_type?(fields_to_update)
    valid_asn_type=['PO', 'Inbound', 'Warehouse Transfer']
    if valid_asn_type.include? fields_to_update.asn_type 
       true    
    else
       validation_failed('422', :asn_type, 'Invalid ASN Type')
    end
  end  

  def valid_purchase_order_nbr?(fields_to_update)
    if (fields_to_update.purchase_order_nbr.nil? || fields_to_update.purchase_order_nbr.blank?) 
      validation_failed('422', :purchase_order_nbr, 'Invalid purchase order')      
    else
       true
    end
  end  
   
   
end