class LocationInventory < ActiveRecord::Base
  
  def self.update_location_inventory(client, warehouse, building, channel, from_location, to_location, item, quantity)
    
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
