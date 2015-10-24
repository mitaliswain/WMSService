require 'utilities/utility'
require 'utilities/response'

include Utility
include Response

class LocationMaster < ActiveRecord::Base
  validates_uniqueness_of :position, scope: [:client, :warehouse, :channel, :building, :area, :zone, :aisle, :bay, :level]
  before_validation :convert_blank_to_null_for_building_and_channel
  
  before_save :default_barcode
  
  def default_barcode
    if area_changed? || zone_changed? || aisle_changed? || bay_changed? or level_changed? || position_changed?
       self.barcode = self.area.to_s + self.zone.to_s + self.aisle.to_s + self.bay.to_s + self.level.to_s + self.position.to_s
    end   
  end
    
end
