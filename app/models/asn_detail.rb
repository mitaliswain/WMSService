require 'utilities/utility'
require 'utilities/response'

include Utility
include Response

class AsnDetail < ActiveRecord::Base
  attr_accessor :message
  
  validates_uniqueness_of :sequence, scope: [:client, :shipment_nbr]
  validates_presence_of  :client, :warehouse, :shipment_nbr, :sequence, :item, :asn_header_id
  validates_presence_of  :building, :channel,  :allow_nil => true
  before_validation :convert_blank_to_null_for_building_and_channel
  after_save :update_asnheader
  
  def update_asnheader
    asn_header = AsnHeader.find(self.asn_header_id)
    raise "No Asn Header record found for Asn Header id #{self.asn_header_id}" if asn_header.nil?
    asn_header.units_rcvd =  asn_header.units_rcvd.to_i + (self.received_qty.to_i - self.received_qty_was.to_i)
    asn_header.cases_rcvd =  asn_header.cases_rcvd.to_i + (self.cases_rcvd.to_i - self.cases_rcvd_was.to_i)
    asn_header.save!
 end
  
end
