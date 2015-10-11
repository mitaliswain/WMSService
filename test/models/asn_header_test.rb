require 'test_helper'

class AsnHeaderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test 'default_status_should_be_created_for_add' do
      new_shipment = Time.now.to_i.to_s
      AsnHeader.create({client: 'WM', warehouse: 'WH1', building: nil, channel: nil, shipment_nbr: new_shipment})
      asn=AsnHeader.find_by_shipment_nbr(new_shipment)
      assert_equal 'Created', asn.record_status, 'Default status should be created'
  end

  test 'default_status_should_be_created_for_add_using_save' do
    new_shipment = Time.now.to_i.to_s
    asn= AsnHeader.new
    asn.client = 'WM'
    asn.warehouse = 'WH1'
    asn.building = nil
    asn.channel = nil
    asn.shipment_nbr= new_shipment
    asn.save
    created_asn=AsnHeader.find_by_shipment_nbr(new_shipment)
    assert_equal 'Created', created_asn.record_status, 'Default status should be created'
  end

  test 'status_for_update_should_not_be_defaulted' do
    new_shipment = Time.now.to_i.to_s
    new_asn= AsnHeader.create({client: 'WM', warehouse: 'WH1', building: nil, channel: nil, shipment_nbr: new_shipment})
    new_asn.record_status = 'Initiated'
    new_asn.save
    updated_asn = AsnHeader.find_by_shipment_nbr(new_shipment)
    assert_equal new_asn.record_status, updated_asn.record_status, 'Status should not change for update'
  end

end


