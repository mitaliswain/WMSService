require 'utilities/response'
require 'utilities/Utility'

module WmsConfiguration
  
  class ConfigurationMaintenance
    
    include Response
    include Utility
    attr_accessor :message, :error
    
    def initialize
      @message = {}
      @error = []
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