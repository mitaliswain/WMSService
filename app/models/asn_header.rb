include Utility

class AsnHeader < ActiveRecord::Base
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
        end  
        @message 
  end

  def add_shipment_header(app_parameters, fields_to_add)
       if valid_data?(fields_to_add)
         shipment_hash = AsnHeader.new 
         app_parameters.each do |field, data|
           shipment_hash.attributes = {field => data}
         end
         fields_to_add.each do |field, data|
            shipment_hash.attributes =  {field => data} 
         end   
         shipment_hash.save!          
      end        
      return @message
  end

  
  def valid_data?(fields_to_update)
    is_valid = true
    fields_to_update.each do |field, value|
        method ="valid_#{field.to_s}?" 
        is_valid = is_valid &&  
                   (respond_to?(method) ? send(method, value)[:status] : true)
    end   
    is_valid
  end 
  
  def valid_asn_type?(asn_type)
    valid_asn_type=['PO', 'Inbound', 'Warehouse Transfer']
    if valid_asn_type.include? asn_type 
       set_valid_message(:asn_type)      
    else
       set_invalid_message(:asn_type, "Not a valid asn type") 
    end
  end  

  def valid_purchase_order_nbr?(po)
    if (po.nil? || po.blank?) 
      set_invalid_message(:po, "Please enter the PO")          
    else
       set_valid_message(:po)   
    end
  end  
   
   
end