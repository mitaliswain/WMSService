require 'utilities/response'
require 'utilities/utility'

module Location

  class LocationMasterMaintenance

    include Response
    include Utility
    attr_accessor :message, :error

    def initialize
      @message = {}
      @error = []
    end
    
    def get_locations(basic_parameters:nil, filter_conditions:nil, expand:nil)

      if expand.nil?
        location_header_data = '*'
      else
        location_header_data = '*'
      end

      location_hash = []
      location_headers = LocationMaster.select(location_header_data).where(filter_conditions)
      location_headers.each { |location_header|
        location_hash << {location_header: location_header}
      }
      location_hash
    end

    def add_location_master(app_parameters, fields_to_add)
      input_obj = app_parameters.merge(fields_to_add).to_hash
      if valid_data?(input_obj) && valid_app_parameters?(input_obj)
       location_master_hash = LocationMaster.new(input_obj)
       location_master_hash = add_derived_data(location_master_hash.clone)
       location_master_hash.save!
        resource_added_successfully("Location #{location_master_hash.id}", "/location_master/#{location_master_hash.id}")
      end
      message
    end

    def update_location_master(app_parameters, id, fields_to_update)
      input_obj = app_parameters.merge(fields_to_update).merge(id: id).to_hash
      if valid_app_parameters?(input_obj) && valid_data?(input_obj)
        location = LocationMaster.find(id)
        fields_to_update.each do |field, data|
          location.attributes =  {field => data}
        end
        location.save!
        resource_updated_successfully("Location #{id}", "/location_master/#{location.id}")
      end
      message
    end

    def valid_data?(input_obj)
      true
    end

    def add_derived_data(location_master_hash)
      location_master_hash
    end

  end
end