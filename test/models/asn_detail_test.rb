require 'test_helper'

class AsnDetailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  fixtures :asn_details
  fixtures :item_masters

  test "update AsnHeader received quantitty" do
    
     old_asn = AsnDetail.where(shipment_nbr: asn_details(:two).shipment_nbr, sequence: asn_details(:two).sequence).first
     old_asn.received_qty = old_asn.received_qty.to_i + 10
     asn_header = AsnHeader.find(old_asn.asn_header_id)
     before_received_qty = asn_header.units_rcvd
     old_asn.save
     asn_header = AsnHeader.find(old_asn.asn_header_id)
     assert_equal(asn_header.units_rcvd, before_received_qty+10, 'update asn received quantity')
  end
  
  test "update AsnHeader case received" do
    
     old_asn = AsnDetail.where(shipment_nbr: asn_details(:two).shipment_nbr, sequence: asn_details(:two).sequence).first
     old_asn.cases_rcvd = old_asn.cases_rcvd.to_i + 10
     asn_header = AsnHeader.find(old_asn.asn_header_id)
     before_case_received = asn_header.cases_rcvd
     old_asn.save
     asn_header = AsnHeader.find(old_asn.asn_header_id)
     assert_equal(asn_header.cases_rcvd, before_case_received+10, 'update asn case received')
  end

  test "update AsnHeader po quantity" do

    old_asn = AsnDetail.where(shipment_nbr: asn_details(:two).shipment_nbr, sequence: asn_details(:two).sequence).first
    old_asn.po_qty = old_asn.po_qty.to_i + 10
    asn_header = AsnHeader.find(old_asn.asn_header_id)
    before_order_qty = asn_header.unit_ordered
    old_asn.save
    asn_header = AsnHeader.find(old_asn.asn_header_id)
    assert_equal(asn_header.unit_ordered, before_order_qty+10, 'update po qty')
  end

  test "should update the total units and total weight of asn header" do
    old_asn = AsnDetail.where(shipment_nbr: asn_details(:two).shipment_nbr, sequence: asn_details(:two).sequence).first
    asn_header = AsnHeader.find(old_asn.asn_header_id)
    AsnDetail.create(client: asn_header.client, warehouse: asn_header.warehouse, building: asn_header.building, channel: asn_header.channel, asn_header_id: asn_header.id, item: item_masters(:one).item, shipped_quantity: 10.0, received_qty: 15, shipment_nbr: asn_header.shipment_nbr, sequence: 998)
    a = AsnDetail.find_by_sequence(998)
    p a.shipped_quantity
    new_asn_header = AsnHeader.find(old_asn.asn_header_id)
    assert_equal(asn_header.total_units + 10 , new_asn_header.total_units, "Add total units")

  end

  test "should_populate_item_details_on_create" do
    item = item_masters(:one)
    asn_header = AsnHeader.find_by_shipment_nbr('Shipment1')
    asn_detail = AsnDetail.create({client: asn_header.client, warehouse: asn_header.warehouse,
                                   channel: asn_header.channel, building: asn_header.building,
                                   asn_header_id: asn_header.id, shipment_nbr: asn_header.shipment_nbr, item: item.item, sequence: 999,})
    assert_equal(item.concept, asn_detail.concept, 'Populate concept from item master')
    assert_equal(item.sku_attribute1, asn_detail.sku_attribute1, 'Populate attribute1 from item master')
    assert_equal(item.sku_attribute2, asn_detail.sku_attribute2, 'Populate attribute2 from item master')
    assert_equal(item.sku_attribute3, asn_detail.sku_attribute3, 'Populate attribute3 from item master')
    assert_equal(item.retail_price, asn_detail.retail_price, 'Populate retail price from item master')
  end

end


