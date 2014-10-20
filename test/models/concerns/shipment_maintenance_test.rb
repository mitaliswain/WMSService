require 'test_helper'


class ShipmentMaintenanceTest<ActiveSupport::TestCase

fixtures :asn_headers
fixtures :asn_details
  

  test "with valid data" do
    asn = Shipment::ShipmentMaintenance.new
    app_parameters = {client: 'WM', warehouse: 'WH1', channel: 'RTL', building: 'DIST1'}
    response = asn.valid_app_parameters?(app_parameters)
    assert_equal(true, response, 'testing with valid parameter')
    
  end

  test "with nil client" do
    asn = Shipment::ShipmentMaintenance.new
    app_parameters = {client: nil, warehouse: nil, channel: 'RTL', building: 'DIST1'}
    response = asn.valid_app_parameters?(app_parameters)
    assert_equal('422', asn.message[:status], 'testing with nil client')    
  end

  test "with no client" do
    asn = Shipment::ShipmentMaintenance.new    
    app_parameters = {warehouse: 'WH1', channel: 'RTL', building: 'DIST1'}
    response = asn.valid_app_parameters?(app_parameters)
    assert_equal('422', asn.message[:status], 'testing with no client')    
  end


  test "with nil warehouse" do
    asn = Shipment::ShipmentMaintenance.new    
    app_parameters = {client: 'WM', warehouse: nil, channel: 'RTL', building: 'DIST1'}
    response = asn.valid_app_parameters?(app_parameters)
    assert_equal('422', asn.message[:status], 'testing with nil warehouse') 
  end

  test "with without warehouse" do
    asn = Shipment::ShipmentMaintenance.new    
    app_parameters = {client:'WM', channel: 'RTL', building: 'DIST1'}
    response = asn.valid_app_parameters?(app_parameters)
    assert_equal('422', asn.message[:status], 'testing with no warehouse')    
  end

  test "with nil channel" do
    asn = Shipment::ShipmentMaintenance.new    
    app_parameters = {client: 'WM', warehouse: 'WH1', channel: nil, building: 'DISTx'}
    response = asn.valid_app_parameters?(app_parameters)
    assert_equal(true, response, 'testing with nil channel')
  end

  test "without channel" do
    asn = Shipment::ShipmentMaintenance.new    
    app_parameters = {client: 'WM', warehouse: 'WH1',  building: 'DIST'}
    response = asn.valid_app_parameters?(app_parameters)
    assert_equal('422', asn.message[:status], 'testing without channel')
  end
  
 
  test "with nil building" do
    asn = Shipment::ShipmentMaintenance.new    
    app_parameters = {client: 'WM', warehouse: 'WH1', channel: 'RTL', building: nil}
    response = asn.valid_app_parameters?(app_parameters)
    assert_equal(true, response, 'testing with nil building')
    
  end
  
   test "without building" do
    asn = Shipment::ShipmentMaintenance.new
    app_parameters = {client: 'WM', warehouse: 'WH1', channel: 'RTL'}
    response = asn.valid_app_parameters?(app_parameters)
    assert_equal('422', asn.message[:status], 'testing without building')
    end


   test "update header with single column" do
     asn = Shipment::ShipmentMaintenance.new     
     old_asn = AsnHeader.find_by_shipment_nbr(asn_headers(:one).shipment_nbr)
     app_parameters = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil}
     fields_to_update = {purchase_order_nbr: asn_headers(:one).shipment_nbr + 'New'}
     asn.update_shipment_header(app_parameters, old_asn.id, fields_to_update)
     new_asn = AsnHeader.find_by_shipment_nbr(asn_headers(:one).shipment_nbr)
     assert_equal(asn_headers(:one).shipment_nbr + 'New', new_asn.purchase_order_nbr, 'Update single field for asn header')
     
   end

   test "update header with multiple columns" do
     asn = Shipment::ShipmentMaintenance.new     
     old_asn = AsnHeader.find_by_shipment_nbr(asn_headers(:one).shipment_nbr)
     app_parameters = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil}
     
     fields_to_update = {purchase_order_nbr: asn_headers(:one).shipment_nbr + 'New',
                         appointment_nbr: '12345',
                         asn_type: asn_headers(:one).asn_type.to_s  }
     asn.update_shipment_header(app_parameters, old_asn.id, fields_to_update)
     new_asn = AsnHeader.find_by_shipment_nbr(asn_headers(:one).shipment_nbr)
     assert_equal(asn_headers(:one).shipment_nbr + 'New', new_asn.purchase_order_nbr, 'Update single field for asn header')
     assert_equal('12345', new_asn.appointment_nbr, ' Check appointment number')
     assert_equal(asn_headers(:one).asn_type.to_s, new_asn.asn_type, 'Check ASN Type')
     
   end
   
  test "unique shipment number for a client" do
    asn = Shipment::ShipmentMaintenance.new       
    old_asn = AsnHeader.find_by_shipment_nbr(asn_headers(:one).shipment_nbr)
    app_parameters = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil}
    fields_to_update = {shipment_nbr: asn_headers(:two).shipment_nbr}
    
    assert_raises(ActiveRecord::RecordInvalid) do
      asn.update_shipment_header(app_parameters, old_asn.id, fields_to_update)     
    end  
  end

  test "unique shipment number for different client" do 
    asn = Shipment::ShipmentMaintenance.new      
    old_asn = AsnHeader.find_by_shipment_nbr(asn_headers(:four).shipment_nbr)
    app_parameters = {client: 'WM2', warehouse: 'WH1', channel: nil, building: nil}
    fields_to_update = {shipment_nbr: asn_headers(:two).shipment_nbr}
    asn.update_shipment_header(app_parameters, old_asn.id, fields_to_update)     
  end
  
   test "add asn header" do
     asn = Shipment::ShipmentMaintenance.new     
     app_parameters = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil}
     
     fields_to_add = {   shipment_nbr: 'shipmentx',
                         purchase_order_nbr: asn_headers(:one).shipment_nbr + 'New',
                         appointment_nbr: '12345',
                         asn_type: asn_headers(:one).asn_type.to_s   }
     asn.add_shipment_header(app_parameters, fields_to_add)
     new_asn = AsnHeader.find_by_shipment_nbr('shipmentx')
     assert_equal(asn_headers(:one).shipment_nbr + 'New', new_asn.purchase_order_nbr, 'check purchase_order_nbr')
     assert_equal('12345', new_asn.appointment_nbr, ' Check appointment number')
     assert_equal(asn_headers(:one).asn_type.to_s , new_asn.asn_type, 'Check ASN Type')
     
   end

   test "add asn header with invalid data" do
     asn = Shipment::ShipmentMaintenance.new     
     app_parameters = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil}
     
     fields_to_add = {   shipment_nbr: 'shipment_invalid_field',
                         purchase_order_nbr: asn_headers(:one).shipment_nbr + 'New',
                         appointment_nbr: '12345',
                         asn_type: 'Invalid asn'   }
     message =asn.add_shipment_header(app_parameters, fields_to_add)
     new_asn = AsnHeader.find_by_shipment_nbr('shipment_invalid_field')
     assert_equal(nil, new_asn, 'Shipment not added')
     assert_equal('422', message[:status], 'Can not add header with invalid field')     
   end


  test "validate data with incorrect asn type" do
    asn = Shipment::ShipmentMaintenance.new       
    fields_to_update = {asn_type: 'incorrect asn type'}
    assert_equal(false, asn.valid_data?(fields_to_update), "Incorrect asn type")
  end

  test "validate data with incorrect multiple fields" do 
    asn = Shipment::ShipmentMaintenance.new  
    fields_to_update = { asn_type: 'invalid',  purchase_order_nbr: ' '}
    assert_equal(false, asn.valid_data?(fields_to_update), "validate data with incorrect multiple fields")
    assert_equal(:purchase_order_nbr, asn.message[:errors][1][:field], "validate data with incorrect multiple fields")
    assert_equal(:asn_type, asn.message[:errors][0][:field], "validate data with incorrect multiple fields")

  end   
 

   test "validate data with correct single field" do   
    asn = Shipment::ShipmentMaintenance.new     
    fields_to_update = {asn_type: 'PO'}
    assert_equal(true, asn.valid_data?(fields_to_update), "correct asn type ")
  end 
   
  test "validate data with correct multiple fields" do  
    asn = Shipment::ShipmentMaintenance.new     
    fields_to_update = {asn_type: 'PO', purchase_order_nbr: "1234"}
    assert_equal(true, asn.valid_data?(fields_to_update), "correct asn type")
  end   

  test "Valid hot item po" do
   asn = Shipment::ShipmentMaintenance.new  
   fields_to_update = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, hot_item_po: "Y"}
   response = asn.valid_hot_item_po?(fields_to_update) 
   assert_equal(true, response, 'Valid Hot item po for true' )    
   fields_to_update = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, hot_item_po: "N"}
   response = asn.valid_hot_item_po?(fields_to_update) 
   assert_equal(true, response, 'Valid Hot item po for false' )    
  end
  
  test "Valid purchase order nbr blank or nill " do
  asn = Shipment::ShipmentMaintenance.new  
  fields_to_update = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, purchase_order_nbr: ""}
  response = asn.valid_purchase_order_nbr?(fields_to_update) 
  assert_equal(false, response, 'blank purchase order number' )   
  
  fields_to_update = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, purchase_order_nbr: nil}
  response = asn.valid_purchase_order_nbr?(fields_to_update) 
  assert_equal(false, response, 'nill purchase order nbr' )    
  end
  
   test "Valid vendor nbr blank or nill " do
  asn = Shipment::ShipmentMaintenance.new  
  fields_to_update = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, vendor_nbr: ""}
  response = asn.valid_vendor_nbr?(fields_to_update) 
  assert_equal(false, response, 'blank vendor number' )   
  
  fields_to_update = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, vendor_nbr: nil}
  response = asn.valid_vendor_nbr?(fields_to_update) 
  assert_equal(false, response, 'nill vendor number' )    
  end
  
  test "update detail with single column" do
     asn = Shipment::ShipmentMaintenance.new 
     old_asn = AsnDetail.where(shipment_nbr: asn_details(:two).shipment_nbr, sequence: asn_details(:two).sequence).first
     app_parameters = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil}
     fields_to_update = {shipped_quantity: (asn_details(:two).shipped_quantity).to_i + 1}
     asn.update_shipment_detail(app_parameters, old_asn.id, fields_to_update)
     new_asn = AsnDetail.where(shipment_nbr: asn_details(:two).shipment_nbr, sequence: asn_details(:two).sequence).first
     assert_equal((asn_details(:two).shipped_quantity).to_i + 1, new_asn.shipped_quantity, 'Update single field for asn details')
     
   end
   
    test "update detail with multiple columns" do
      asn = Shipment::ShipmentMaintenance.new 
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
     asn = Shipment::ShipmentMaintenance.new 
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
     asn = Shipment::ShipmentMaintenance.new 
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
  asn = Shipment::ShipmentMaintenance.new 
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, hot_item: ""}
  response = asn.valid_hot_item?(input_obj) 
   assert_equal(false, response, 'Invalid Hot item' )    
  end
   
  test "blank or nill item" do
  asn = Shipment::ShipmentMaintenance.new   
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, item: ""}
  response = asn.valid_item?(input_obj) 
  assert_equal(false, response, 'blank item' )   
  
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, item: nil}
  response = asn.valid_item?(input_obj) 
  assert_equal(false, response, 'nill item' )    
  end
  
  test "item in item master" do
  item = ItemMaster.all.first
  asn = Shipment::ShipmentMaintenance.new  
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, item: item.item}
  response = asn.valid_item?(input_obj) 
  assert_equal(true, response, 'valid item' )   
  
  item.destroy
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, item: item.item}
  response = asn.valid_item?(input_obj) 
  assert_equal(false, response, 'Item not found in item master' )    
  end
  
  
  test "Valid hot item" do
  asn = Shipment::ShipmentMaintenance.new  
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, hot_item: "Y"}
  response = asn.valid_hot_item?(input_obj) 
   assert_equal(true, response, 'Valid Hot item for true' )    
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, hot_item: "N"}
  response = asn.valid_hot_item?(input_obj) 
   assert_equal(true, response, 'Valid Hot item for false' )    
  end
  
  test "Valid lot control" do
  asn = Shipment::ShipmentMaintenance.new   
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, track_lotcontrol: "Y"}
  response = asn.valid_track_lot_control?(input_obj) 
   assert_equal(true, response, 'Valid Lot control for Y' )    
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, track_lotcontrol: "N"}
  response = asn.valid_track_lot_control?(input_obj) 
   assert_equal(true, response, 'Valid Lot control for N' )    
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, track_lotcontrol: "K"}
  response = asn.valid_track_lot_control?(input_obj) 
   assert_equal(false, response, 'Valid Lot control for anything else Y or N' )    

  end
  
  test "Valid serial number" do
  asn = Shipment::ShipmentMaintenance.new   
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, track_serial_nbr: "Y"}
  response = asn.valid_track_serial_nbr?(input_obj) 
  assert_equal(true, response, 'Valid Serial number for true' )    
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, track_serial_nbr: "N"}
  response = asn.valid_track_serial_nbr?(input_obj) 
  assert_equal(true, response, 'Valid Serial number for false' )    
  end
  
  test "Valid Country of origin" do
  asn = Shipment::ShipmentMaintenance.new   
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, track_coo: "Y"}
  response = asn.valid_track_coo?(input_obj) 
  assert_equal(true, response, 'Valid coo for true' )    
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, track_coo: "N"}
  response = asn.valid_track_coo?(input_obj) 
  assert_equal(true, response, 'Valid coo for false' )    
  end
  
   test "Valid Priority" do
  asn = Shipment::ShipmentMaintenance.new   
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, priority: "Y"}
  response = asn.valid_priority?(input_obj) 
   assert_equal(true, response, 'Valid priority true' )    
  input_obj = {client: 'WM', warehouse: 'WH1', channel: nil, building: nil, priority: "N"}
  response = asn.valid_priority?(input_obj) 
   assert_equal(true, response, 'Valid priority false' )    
  end
    
end
 

