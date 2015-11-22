require 'utilities/utility'
require 'utilities/response'

include Utility
include Response
class CaseHeader < ActiveRecord::Base
  validates_presence_of  :client, :warehouse, :case_id
  validates_presence_of  :building, :channel, :allow_nil => true
  validates_uniqueness_of :case_id, scope: :client
  before_validation :convert_blank_to_null_for_building_and_channel

  after_update :update_location_inventory , :if => :location_changed?

  def update_location_inventory
    CaseDetail.where(case_header_id: self.id).each do |case_detail|
      LocationInventory.update_location_inventory(self.client, self.warehouse, self.channel, self.building,
                                                  self.location_was, self.location, case_detail.item, case_detail.quantity)
    end

  end

end
