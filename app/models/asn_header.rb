require 'utilities/utility'
require 'utilities/response'

include Utility
include Response

class AsnHeader < ActiveRecord::Base
  attr_reader :message
  
  validates_uniqueness_of :shipment_nbr, scope: :client
  validates_presence_of  :client, :warehouse, :shipment_nbr
  validates_presence_of  :building, :channel, :allow_nil => true
  before_validation :convert_blank_to_null_for_building_and_channel

  before_create :default_status

  def default_status
    self.record_status = 'Created'
  end
end