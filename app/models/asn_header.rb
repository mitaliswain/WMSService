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
        @message 
      end 
  end

  
  def valid_app_parameters?(app_parameters)
    return set_invalid_message(:client)    if !app_parameters.has_key?(:client) || app_parameters [:client].nil? 
    return set_invalid_message(:warehouse) if !app_parameters.has_key?(:warehouse) || app_parameters [:warehouse].nil?     
    return set_invalid_message(:channel)   if !app_parameters.has_key?(:channel)
    return set_invalid_message(:building)  if !app_parameters.has_key?(:building)        
    set_valid_message
  end
  
  def valid_data?(fields_to_update)
    true
  end 
   
  def set_invalid_message(invalid_field)
    @message = { status: false, message: ["Invalid field: #{invalid_field}"] }
  end
  
  def set_valid_message(message=nil)
    @message = { status: true, message: ["validation pass: #{message}"] }
  end
  
end