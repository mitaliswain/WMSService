require 'test_helper'

class AsnDetailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  fixtures :asn_details
  
  asn = AsnDetail.new
  
  test "update detail with single column" do
     old_asn = AsnDetail.where(shipment_nbr: asn_details(:two).shipment_nbr, sequence: asn_details(:two).sequence).first
     app_parameters = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil}
     fields_to_update = {shipped_quantity: (asn_details(:two).shipped_quantity).to_i + 1}
     asn.update_shipment_detail(app_parameters, old_asn.id, fields_to_update)
     new_asn = AsnDetail.where(shipment_nbr: asn_details(:two).shipment_nbr, sequence: asn_details(:two).sequence).first
     assert_equal((asn_details(:two).shipped_quantity).to_i + 1, new_asn.shipped_quantity, 'Update single field for asn details')
     
   end
   
    test "update detail with multiple columns" do
      old_asn = AsnDetail.where(shipment_nbr: asn_details(:two).shipment_nbr, sequence: asn_details(:two).sequence).first
      app_parameters = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil}
     
      fields_to_update = {shipped_quantity: (asn_details(:two).shipped_quantity).to_i + 1,
                         received_qty: (asn_details(:two).received_qty).to_i + 1,
                         verified_qty: (asn_details(:two).verified_qty).to_i + 1 }
      asn.update_shipment_detail(app_parameters, old_asn.id, fields_to_update)
      new_asn = AsnDetail.where(shipment_nbr: asn_details(:two).shipment_nbr, sequence: asn_details(:two).sequence).first
      assert_equal((asn_details(:two).shipped_quantity).to_i + 1, new_asn.shipped_quantity, 'Update shipped quantity for asn details')
      assert_equal((asn_details(:two).received_qty).to_i + 1, new_asn.received_qty, 'Update  received quantity for asn details')
      assert_equal((asn_details(:two).verified_qty).to_i + 1, new_asn.verified_qty, 'Update verified quantity for asn details')
     
   end
   
   test "add asn detail" do
     app_parameters = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil}
     asn_header = AsnHeader.find_by_shipment_nbr(asn_details(:two).shipment_nbr)
     fields_to_add = {  asn_header_id: asn_header.id,
                        item: '123467',
                        shipment_nbr: asn_details(:two).shipment_nbr,
                        sequence: '3', 
                        shipped_quantity: '40',
                        received_qty: '20',
                        verified_qty: '20' }
     response = asn.add_shipment_detail(app_parameters, fields_to_add)
     assert_equal('201', response.status, "shipment detail added successfully")
     new_asn = AsnDetail.where(shipment_nbr:  asn_details(:two).shipment_nbr).order(:sequence).last
     assert_equal(40, new_asn.shipped_quantity, ' Check shipment quantity')
     assert_equal(20, new_asn.received_qty, 'Check received quantity')
     assert_equal(20, new_asn.verified_qty, 'Check verified quantity')
     
   end
   
   test "add asn detail with non symbolize keys" do
     app_parameters = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil}
     asn_header = AsnHeader.find_by_shipment_nbr(asn_details(:two).shipment_nbr)
     fields_to_add = {  'asn_header_id' => asn_header.id,
                        'item' => '123467',
                        'shipment_nbr'=> asn_details(:two).shipment_nbr,
                        'sequence'=> 4, 
                        'shipped_quantity'=> '40',
                        'received_qty'=> '20',
                        'verified_qty'=> '20' }
     response = asn.add_shipment_detail(app_parameters, fields_to_add)
     assert_equal('201', response.status, "shipment detail added successfully")
     new_asn = AsnDetail.where(shipment_nbr:  asn_details(:two).shipment_nbr).order(:sequence).last
     assert_equal(40, new_asn.shipped_quantity, ' Check shipment quantity')
     assert_equal(20, new_asn.received_qty, 'Check received quantity')
     assert_equal(20, new_asn.verified_qty, 'Check verified quantity')
     
   end

  test "Invalid hot item" do
  asn = AsnDetail.new  
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, hot_item: ""}
  response = asn.valid_hot_item?(input_obj) 
   assert_equal(false, response, 'Invalid Hot item' )    
  end
   
  test "blank or nill item" do
  asn = AsnDetail.new  
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, item: ""}
  response = asn.valid_item?(input_obj) 
  assert_equal(false, response, 'blank item' )   
  
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, item: nil}
  response = asn.valid_item?(input_obj) 
  assert_equal(false, response, 'nill item' )    
  end
  
  
  test "Valid hot item" do
  asn = AsnDetail.new  
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, hot_item: "Y"}
  response = asn.valid_hot_item?(input_obj) 
   assert_equal(true, response, 'Valid Hot item for true' )    
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, hot_item: "N"}
  response = asn.valid_hot_item?(input_obj) 
   assert_equal(true, response, 'Valid Hot item for false' )    
  end
  
  test "Valid lot control" do
  asn = AsnDetail.new  
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, track_lotcontrol: "Y"}
  response = asn.valid_track_lot_control?(input_obj) 
   assert_equal(true, response, 'Valid Lot control for true' )    
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, track_lotcontrol: "N"}
  response = asn.valid_track_lot_control?(input_obj) 
   assert_equal(false, response, 'Valid Lot control for false' )    
  end
  
  test "Valid serial number" do
  asn = AsnDetail.new  
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, track_serial_nbr: "Y"}
  response = asn.valid_track_serial_nbr?(input_obj) 
   assert_equal(true, response, 'Valid Serial number for true' )    
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, track_serial_nbr: "N"}
  response = asn.valid_track_serial_nbr?(input_obj) 
   assert_equal(true, response, 'Valid Serial number for false' )    
  end
  
  test "Valid Country of origin" do
  asn = AsnDetail.new  
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, track_coo: "Y"}
  response = asn.valid_track_coo?(input_obj) 
   assert_equal(true, response, 'Valid coo for true' )    
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, track_coo: "N"}
  response = asn.valid_track_coo?(input_obj) 
   assert_equal(true, response, 'Valid coo for false' )    
  end
  
   test "Valid Priority" do
  asn = AsnDetail.new  
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, priority: "Y"}
  response = asn.valid_priority?(input_obj) 
   assert_equal(true, response, 'Valid priority true' )    
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, priority: "N"}
  response = asn.valid_priority?(input_obj) 
   assert_equal(true, response, 'Valid priority false' )    
  end
end


