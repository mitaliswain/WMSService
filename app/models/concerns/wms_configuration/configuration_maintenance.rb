require 'utilities/response'
require 'utilities/utility'

module WmsConfiguration
  
  class ConfigurationMaintenance
    
    include Response
    include Utility
    attr_accessor :message, :error
    
    def initialize
      @message = {}
      @error = []
    end

    def get_configuration(basic_parameters:nil, filter_conditions:nil, expand:nil)

      if expand.nil?
        #configuration_header_data = [:id, :shipment_nbr, :asn_type, :ship_via, :record_status]
        configuration_header_data = '*'
      else
        configuration_header_data = '*'
      end

      configuration_hash = []
      configuration_headers = GlobalConfiguration.select(configuration_header_data).where(filter_conditions)
      configuration_headers.each do |configuration_header|
          configuration_hash << {configuration_header: configuration_header}
      end
      configuration_hash
    end


    def update_configuration(app_parameters, id, fields_to_update)
       input_obj = app_parameters.merge(fields_to_update).merge(id: id).to_hash
       if valid_app_parameters?(input_obj) && valid_data?(input_obj)
         configuration = GlobalConfiguration.find(id)   
         fields_to_update.each do |field, data|
            configuration.attributes =  {field => data} 
         end   
         configuration.save!
         resource_updated_successfully("Configuration #{id}") 
        end  
        message 
    end
    
    def valid_data?(input_obj)
      true
    end
      
  end
end