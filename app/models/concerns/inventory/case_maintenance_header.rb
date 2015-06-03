module Inventory
  require 'utilities/utility'
  require 'utilities/response'
  
  include Utility
  include Response
  
  module CaseMaintenanceHeader 
       extend ActiveSupport::Concern
       
       def update_case_header(app_parameters, id, fields_to_update)
         input_obj = app_parameters.merge(fields_to_update).merge(id: id).to_hash
         if  valid_data?(input_obj)
           case_hash = CaseHeader.find(id)   
           fields_to_update.each do |field, data|
            case_hash.attributes =  {field => data} 
           end   
           case_hash.save!
           resource_updated_successfully("Case #{id}") 
          end  
          message 
      end
      
    def add_case_header(app_parameters, fields_to_add)
         input_obj = app_parameters.merge(fields_to_add).to_hash
         if valid_data?(input_obj) && valid_app_parameters?(input_obj)
            case_hash = CaseHeader.new(input_obj)  
            case_hash = add_derived_data(case_hash.clone)
           case_hash.save!
           resource_added_successfully("case #{case_hash.id}", "/case/#{case_hash.id}")
         end        
         message  
    end

   def add_derived_data(case_header)
     basic_parameters = {client: case_header.client, warehouse: case_header.warehouse, channel: nil, building: nil}
     case_header.case_id= get_next_one_up_number(basic_parameters, 'CASE') if (case_header.case_id.nil? or case_header.case_id.blank?)
     case_header.record_status = 'Created' if case_header.record_status.nil? or case_header.record_status.blank?
     case_header
   end
  
  
    def valid_data?(fields_to_update)
      is_valid = true
      fields_to_update.each do |field, value|
          method ="valid_#{field.to_s}?"
          is_valid = (respond_to?(method) ? send(method, fields_to_update) : true)  && is_valid                 
      end   
      is_valid
    end


    def valid_shipment_nbr?(fields_to_update)
      shipment = AsnHeader.where(client: fields_to_update.client, warehouse: fields_to_update.warehouse)
                          .where(building: fields_to_update.building.to_nil, channel: fields_to_update.channel.to_nil)
                          .where(shipment_nbr: fields_to_update.shipment_nbr).first                    
      if shipment
         true    
      else
         validation_failed('422', :shipment_nbr, 'Invalid Shipment Number')
      end
   end

   def valid_location?(fields_to_update)
     location = LocationMaster.where(client: fields_to_update.client, warehouse: fields_to_update.warehouse)
                    .where(building: fields_to_update.building.to_nil, channel: fields_to_update.channel.to_nil)
                    .where(barcode: fields_to_update.location).first
     if location
       true
     else
       validation_failed('422', :shipment_nbr, 'Invalid Location')
     end
   end

  end

end
