require 'utilities/response'
require 'utilities/utility'

module Location

  class LocationTypeMaintenance

    include Response
    include Utility
    attr_accessor :message, :error

    def initialize
      @message = {}
      @error = []
    end

    def add_location_type(app_parameters, fields_to_add)
      input_obj = app_parameters.merge(fields_to_add).to_hash
      if valid_data?(input_obj) && valid_app_parameters?(input_obj)
        location_type_hash = LocationType.new(input_obj)
        location_type_hash = add_derived_data(location_type_hash.clone)
        location_type_hash.save!
        resource_added_successfully("LocationType #{location_type_hash.id}", "/location_type/#{location_type_hash.id}")
      end
      message
    end

    def update_location_type(app_parameters, id, fields_to_update)
      input_obj = app_parameters.merge(fields_to_update).merge(id: id).to_hash
      if valid_app_parameters?(input_obj) && valid_data?(input_obj)
       location_type = LocationType.find(id)
        fields_to_update.each do |field, data|
          location_type.attributes =  {field => data}
        end
        location_type.save!
        resource_updated_successfully("LocationType #{id}")
      end
      message
    end

    def valid_data?(input_obj)
      true
    end

    def add_derived_data(location_type_hash)
      location_type_hash
    end

  end
end