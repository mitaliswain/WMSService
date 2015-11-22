require 'utilities/utility'
require 'utilities/response'

include Utility
include Response

class CaseDetail < ActiveRecord::Base
  validates_uniqueness_of :item, scope: [:client, :id]
  validates_presence_of  :client, :warehouse, :case_id, :item, :case_header_id
  validates_presence_of  :building, :channel,  :allow_nil => true
  before_validation :convert_blank_to_null_for_building_and_channel

  after_save :update_location_inventory , :if => :quantity_changed?
  after_save :update_case_header_quantity , :if => :quantity_changed?

  def update_location_inventory
    case_header = CaseHeader.find(self.case_header_id)
    if case_header
        LocationInventory.update_location_inventory(self.client, self.warehouse, self.building, self.channel, nil, case_header.location, self.item, ( self.quantity - self.quantity_was.to_i), case_id)
    end
  end

  def update_case_header_quantity
    case_header = CaseHeader.find(self.case_header_id)
    case_header.quantity = case_header.quantity.to_i + (self.quantity.to_i - self.quantity_was.to_i )
    case_header.save!
  end


end
