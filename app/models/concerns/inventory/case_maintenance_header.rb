module Inventory
  require 'utilities/utility'
  require 'utilities/response'
  
  include Utility
  include Response
  
  module CaseMaintenanceHeader 
       extend ActiveSupport::Concern
       
       def update_case_header(app_parameters, id, fields_to_update)
         input_obj = app_parameters.merge(fields_to_update).merge(id: id).to_hash
         if valid_app_parameters?(input_obj) && valid_data?(input_obj)
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
            shipment_hash = add_derived_data(shipment_hash.clone)
           shipment_hash.save!    
           resource_added_successfully("Shipment #{shipment_hash.id}", "/shipment/#{shipment_hash.id}")                 
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
  end
end