require 'utilities/utility'
require 'utilities/response'

include Utility
include Response

class AsnDetail < ActiveRecord::Base
  attr_accessor :message

  validates_uniqueness_of :sequence, scope: [:client, :shipment_nbr]
  validates_presence_of :client, :warehouse, :shipment_nbr, :sequence, :item, :asn_header_id
  validates_presence_of :building, :channel, :allow_nil => true
  before_validation :convert_blank_to_null_for_building_and_channel
  before_create :default_status, :get_item_details
  before_save :get_item_details, :if => :item_changed?


  after_save :update_asn_header_quantities_and_units

  def default_status
    self.record_status = 'Created'
  end

  def get_item_details
    item = ItemMaster.where(client: self.client, item: self.item).first
    self.concept = item.concept
    self.description = item.description
    self.short_desc = item.short_desc
    self.barcode = item.barcode
    self.sku_attribute1 = item.sku_attribute1
    self.sku_attribute2 = item.sku_attribute2
    self.sku_attribute3 = item.sku_attribute3
    self.sku_attribute4 = item.sku_attribute4
    self.sku_attribute5 = item.sku_attribute5
    self.sku_attribute6 = item.sku_attribute6
    self.sku_attribute7 = item.sku_attribute7
    self.sku_attribute8 = item.sku_attribute8
    self.sku_attribute9 = item.sku_attribute9
    self.sku_attribute10 = item.sku_attribute10
    self.inventory_type  = item.inventory_type
    self.coo = item.coo
    self.uom= item.uom
    self.unit_cost = item.unit_cost
    self.retail_price = item.retail_price
  end

  def update_asn_header_quantities_and_units
    if self.received_qty_changed? or self.cases_rcvd_changed? or self.po_qty_changed? or self.shipped_quantity_changed?
      asn_header = AsnHeader.find(self.asn_header_id)
      asn_header.units_rcvd = asn_header.units_rcvd.to_i + (self.received_qty.to_i - self.received_qty_was.to_i)
      asn_header.cases_rcvd = asn_header.cases_rcvd.to_i + (self.cases_rcvd.to_i - self.cases_rcvd_was.to_i)
      asn_header.unit_ordered = asn_header.unit_ordered.to_i + (self.po_qty.to_i - self.po_qty_was.to_i)
      asn_header.total_units = asn_header.total_units.to_i + (self.shipped_quantity.to_i - shipped_quantity_was.to_i)
      asn_header.total_weight = asn_header.total_units.to_i * self.unit_wgt.to_i
      asn_header.save!
    end
  end


  def update_asn_header_units
    if self.received_qty_changed? or self.cases_rcvd_changed? or self.po_qty_changed?
      asn_header = AsnHeader.find(self.asn_header_id)
      asn_header.units_rcvd = asn_header.units_rcvd.to_i + (self.received_qty.to_i - self.received_qty_was.to_i)
      asn_header.cases_rcvd = asn_header.cases_rcvd.to_i + (self.cases_rcvd.to_i - self.cases_rcvd_was.to_i)
      asn_header.unit_ordered = asn_header.unit_ordered.to_i + (self.po_qty.to_i - self.po_qty_was.to_i)
      asn_header.save!
    end
  end

end
