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
    def update_header
    asn = Shipment::ShipmentMaintenance.new
    message = asn.update_shipment_header(params[:app_parameters], params[:id], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
   rescue Exception => e
    asn.fatal_error(e.message)
    render json: asn.message.to_json, status: '500'
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