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

    def get_configurations(basic_parameters:nil, filter_conditions:nil, expand:nil)

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

    def add_configuration(app_parameters, fields_to_add)
      input_obj = app_parameters.merge(fields_to_add).to_hash
      if valid_data?(input_obj) && valid_app_parameters?(input_obj)
        configuration_hash = GlobalConfiguration.new(input_obj)
        configuration_hash = add_derived_data(configuration_hash.clone)
        configuration_hash.save!
        resource_added_successfully("configuration #{configuration_hash.id}", "/configuration/#{configuration_hash.id}")
      end
      message
    end
    

    def bulk_add_of_configuration(app_parameters, configuration_headers)
       messages = []
       status = '201'
       configuration_headers.each do |configuration|
         response = add_configuration(app_parameters, configuration["configuration_header"])
         messages << response
         status = '202' if response[:status] != '201' 
       end
       status == '201' ? resource_added_successfully("Configuration", messages)   : operation_partial_successful("Configuration", messages) 
       message
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

    def set_configuration(app_parameters,filter_conditions, key ,fields_to_update)
      GlobalConfiguration.set_configuration({value: fields_to_update[:value]}, app_parameters.merge(filter_conditions).merge(key:key))
    end

def valid_data?(fields_to_update)
          is_valid = true
          fields_to_update.each do |field, value|
              method ="valid_#{field.to_s}?"
              is_valid = (respond_to?(method) ? send(method, fields_to_update) : true)  && is_valid
          end
          is_valid
        end

        def valid_warehouse?(fields_to_update)
          if fields_to_update.warehouse.present?
             true
          else
             validation_failed('422', :warehouse, 'Invalid Warehouse')
          end
        end
    
    def add_derived_data(item_master_hash)
      basic_parameters = {client: item_master_hash.client, warehouse: item_master_hash.warehouse, channel: nil, building: nil}
      item_master_hash
    end
      
  end
end