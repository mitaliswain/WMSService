require 'utilities/utility'
require 'utilities/response'

include Utility
include Response

class CaseDetail < ActiveRecord::Base
  validates_uniqueness_of :item, scope: [:client, :case_id]
  validates_presence_of  :client, :warehouse, :case_id, :item, :case_header_id
  validates_presence_of  :building, :channel,  :allow_nil => true
  before_validation :convert_blank_to_null_for_building_and_channel

  after_save :update_location_inventory , :if => :quantity_changed?

  def update_location_inventory

    case_header = CaseHeader.find(self.case_header_id)

    if case_header
        location_inventory = LocationInventory.where(barcode: case_header.location, item: self.item).first || LocationInventory.new
        location_inventory.client = self.client
        location_inventory.warehouse = self.warehouse
        location_inventory.building = self.building
        location_inventory.channel = self.channel

        location_inventory.barcode = case_header.location
        location_inventory.item = self.item
        location_inventory.quantity = self.quantity
        location_inventory.save!
     end

  end

end
