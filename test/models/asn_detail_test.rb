require 'test_helper'

class AsnDetailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  fixtures :asn_details
  
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
end


