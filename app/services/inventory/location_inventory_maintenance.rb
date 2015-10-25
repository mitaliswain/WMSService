require 'utilities/response'
require 'utilities/utility'

module Inventory
  
  class LocationInventoryMaintenance
    
    include Response
    include Utility
    attr_accessor :message, :error
    
    def initialize
      @message = {}
      @error = []
    end

    def get_location_inventory(basic_parameters:nil, filter_conditions:nil, expand:nil)

      if expand.nil?
        location_inventory_data = '*'
      else
        location_inventory_data = '*'
      end

      location_inventory_hash = []
      location_inventories = LocationInventory.select(location_inventory_data).where(filter_conditions)
      location_inventories.each { |location_inventory|
        location_inventory_hash << {location_inventory: location_inventory}
      }
      location_inventory_hash
    end



    def add_location_inventory(app_parameters, fields_to_add)
      input_obj = app_parameters.merge(fields_to_add).to_hash
      if valid_data?(input_obj) && valid_app_parameters?(input_obj)
        location_inventory_hash = LocationInventory.new(input_obj)
        location_inventory_hash = add_derived_data(location_inventory_hash.clone)
        location_inventory_hash.save!
        resource_added_successfully("Location Inventory#{item_master_hash.id}", "/location_inventory/#{location_inventory_hash.id}")
      end
      message
    end

    def update_location_inventory(app_parameters, id, fields_to_update)
       input_obj = app_parameters.merge(fields_to_update).merge(id: id).to_hash
       if valid_app_parameters?(input_obj) && valid_data?(input_obj)
         location_inventory = LocationInventory.find(id)
         fields_to_update.each do |field, data|
            location_inventory.attributes =  {field => data}
         end   
         location_inventory.save!
         resource_updated_successfully("Location Inventory #{id}")
        end  
        message 
    end
    
    def valid_data?(input_obj)
      true
    end

    def add_derived_data(item_master_hash)
      basic_parameters = {client: item_master_hash.client, warehouse: item_master_hash.warehouse, channel: nil, building: nil}
      item_master_hash
    end
      
  end
end