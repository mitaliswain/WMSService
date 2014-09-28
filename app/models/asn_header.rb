include Utility
include Response

class AsnHeader < ActiveRecord::Base
  attr_reader :message
  
  before_save :convert_blank_to_null_for_building_and_channel
  validates_uniqueness_of :shipment_nbr, scope: :client
  validates_presence_of  :client, :warehouse, :shipment_nbr
  validates_presence_of  :building, :channel,  :allow_nil => true
  
   
  def update_shipment_header(app_parameters, id, fields_to_update)
       if valid_app_parameters?(app_parameters) && valid_data?(fields_to_update)
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
       if valid_data?(fields_to_add) && valid_app_paramet
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
        is_valid = (respond_to?(method) ? send(method, value) : true)  && is_valid                 
    end   
    is_valid
  end 
  
  def valid_asn_type?(asn_type)
    valid_asn_type=['PO', 'Inbound', 'Warehouse Transfer']
    if valid_asn_type.include? asn_type 
       true    
    else
       validation_failed('422', :asn_type, 'Invalid ASN Type')
    end
  end  

  def valid_purchase_order_nbr?(po)
    if (po.nil? || po.blank?) 
      validation_failed('422', :purchase_order_nbr, 'Invalid purchase order')      
    else
       true
    end
  end  
   
   
end