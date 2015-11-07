class LocationInventory < ActiveRecord::Base
  
  def self.update_location_inventory(client, warehouse, building, channel, from_location, to_location, item, quantity, case_id=nil)

    from_location ? self.mod_to_location(client, warehouse, building, channel, from_location, to_location, item, quantity) :
                    self.add_to_location(client, warehouse, building, channel, from_location, to_location, item, quantity)

  end


  def self.mod_to_location(client, warehouse, building, channel, from_location, to_location, item, quantity)
    from_location_inventory = self.where(client: client, warehouse: warehouse, building: building, channel: channel, barcode: from_location, item: item).first
    from_location_inventory.quantity = location_inventory.quantity.to_i - quantity
    from_location_inventory.save!
    self.add_to_location(client, warehouse, building, channel, nil, to_location, item, quantity)
  end

  def self.add_to_location(client, warehouse, building, channel, from_location, to_location, item, quantity)
    location_inventory = self.where(client: client, warehouse: warehouse, building: building, channel: channel, barcode: to_location, item: item).first || LocationInventory.new
    location_inventory.client= client
    location_inventory.warehouse = warehouse
    location_inventory.building = building
    location_inventory.channel = channel
    location_inventory.barcode = to_location
    location_inventory.item = item
    location_inventory.quantity = location_inventory.quantity.to_i + quantity
    location_inventory.save!
  end


end
