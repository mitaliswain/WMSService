require 'test_helper'

class AsnHeaderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  fixtures :asn_headers
  
  asn = AsnHeader.new
  
  test "with valid data" do
    app_parameters = {client: 'WM', warehouse: 'WH1', channel: 'RTL', building: 'DIST1'}
    response = asn.valid_app_parameters?(app_parameters)
    assert_equal(true, response[:status], 'testing with valid parameter')
    
  end
  
  test "with invalid client" do
    app_parameters = {client: nil, warehouse: nil, channel: 'RTL', building: 'DIST1'}
    response = asn.valid_app_parameters?(app_parameters)
    assert_equal(false, response[:status], 'testing with nil client')    
  end

  test "with no client" do
    app_parameters = {warehouse: nil, channel: 'RTL', building: 'DIST1'}
    response = asn.valid_app_parameters?(app_parameters)
    assert_equal(false, response[:status], 'testing with no client')    
  end

  test "with invalid warehouse" do
    app_parameters = {client: 'WM', warehouse: nil, channel: 'RTL', building: 'DIST1'}
    response = asn.valid_app_parameters?(app_parameters)
    assert_equal(false, response[:status], 'testing with nil warehouse') 
  end

  test "with without warehouse" do
    app_parameters = {client:'WM', channel: 'RTL', building: 'DIST1'}
    response = asn.valid_app_parameters?(app_parameters)
    assert_equal(false, response[:status], 'testing with no client')    
  end


  test "with nil channel" do
    app_parameters = {client: 'WM', warehouse: 'WH1', channel: nil, building: 'DISTx'}
    response = asn.valid_app_parameters?(app_parameters)
    assert_equal(true, response[:status], 'testing with nil channel')
  end

  test "without channel" do
    app_parameters = {client: 'WM', warehouse: 'WH1',  building: 'DIST'}
    response = asn.valid_app_parameters?(app_parameters)
    assert_equal(false, response[:status], 'testing without channel')
  end
  
 
  test "with nil building" do
    app_parameters = {client: 'WM', warehouse: 'WH1', channel: 'RTL', building: nil}
    response = asn.valid_app_parameters?(app_parameters)
    assert_equal(true, response[:status], 'testing with nil building')
    
  end
  
   test "without building" do
    app_parameters = {client: 'WM', warehouse: 'WH1', channel: 'RTL'}
    response = asn.valid_app_parameters?(app_parameters)
    assert_equal(false, response[:status], 'testing without building')
    end

   
   test "update header with single column" do
     old_asn = AsnHeader.find_by_shipment_nbr(asn_headers(:one).shipment_nbr)
     app_parameters = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil}
     fields_to_update = {purchase_order_nbr: asn_headers(:one).shipment_nbr + 'New'}
     asn.update_shipment_header(app_parameters, old_asn.id, fields_to_update)
     new_asn = AsnHeader.find_by_shipment_nbr(asn_headers(:one).shipment_nbr)
     assert_equal(asn_headers(:one).shipment_nbr + 'New', new_asn.purchase_order_nbr, 'Update single field for asn header')
     
   end

   test "update header with multiple columns" do
     old_asn = AsnHeader.find_by_shipment_nbr(asn_headers(:one).shipment_nbr)
     app_parameters = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil}
     
     fields_to_update = {purchase_order_nbr: asn_headers(:one).shipment_nbr + 'New',
                         appointment_nbr: '12345',
                         asn_type: asn_headers(:one).asn_type.to_s + 'New'   }
     asn.update_shipment_header(app_parameters, old_asn.id, fields_to_update)
     new_asn = AsnHeader.find_by_shipment_nbr(asn_headers(:one).shipment_nbr)
     assert_equal(asn_headers(:one).shipment_nbr + 'New', new_asn.purchase_order_nbr, 'Update single field for asn header')
     assert_equal('12345', new_asn.appointment_nbr, ' Check appointment number')
     assert_equal(asn_headers(:one).asn_type.to_s + 'New', new_asn.asn_type, 'Check ASN Type')
     
   end
   
  test "unique shipment number for a client" do   
    old_asn = AsnHeader.find_by_shipment_nbr(asn_headers(:one).shipment_nbr)
    app_parameters = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil}
    fields_to_update = {shipment_nbr: asn_headers(:two).shipment_nbr}
    
    assert_raises(ActiveRecord::RecordInvalid) do
      asn.update_shipment_header(app_parameters, old_asn.id, fields_to_update)     
    end  
  end

  test "unique shipment number for different client" do   
    old_asn = AsnHeader.find_by_shipment_nbr(asn_headers(:four).shipment_nbr)
    app_parameters = {client: 'WM2', warehouse: 'WH1', channel: nil, building: nil}
    fields_to_update = {shipment_nbr: asn_headers(:two).shipment_nbr}
    asn.update_shipment_header(app_parameters, old_asn.id, fields_to_update)     
  end
  
   test "add asn header" do
     app_parameters = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil}
     
     fields_to_add = {   shipment_nbr: 'shipmentx',
                         purchase_order_nbr: asn_headers(:one).shipment_nbr + 'New',
                         appointment_nbr: '12345',
                         asn_type: asn_headers(:one).asn_type.to_s + 'New'   }
     asn.add_shipment_header(app_parameters, fields_to_add)
     new_asn = AsnHeader.find_by_shipment_nbr('shipmentx')
     assert_equal(asn_headers(:one).shipment_nbr + 'New', new_asn.purchase_order_nbr, 'check purchase_order_nbr')
     assert_equal('12345', new_asn.appointment_nbr, ' Check appointment number')
     assert_equal(asn_headers(:one).asn_type.to_s + 'New', new_asn.asn_type, 'Check ASN Type')
     
   end
   

end

class AsnHeader
  def valid_data?(param)
    true
  end
end
