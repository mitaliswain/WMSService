require 'test_helper'

class ReceiveShipmentControllerTest < ActionDispatch::IntegrationTest
 
fixtures :asn_details
fixtures :asn_headers
fixtures :case_headers
fixtures :case_details
fixtures :location_masters
fixtures :item_masters
fixtures :global_configurations
fixtures :item_inner_packs

  # test "the truth" do
  #   assert true
  # end

  def setup
    @url = '/shipment/' + asn_headers(:one).shipment_nbr + '/' + 'receive'
    @client = 'WM'
    @warehouse = 'WH1'
    @building = nil
    @channel = nil
    @shipment_nbr = asn_headers(:one).shipment_nbr
    @location = location_masters(:one).barcode
    @case_id = 'CASE2'
    @item = asn_details(:one).item
    @quantity = 2
  end  

  def test_validate_location
    post @url, 
        client: @client,
        warehouse: @warehouse,
        channel: @channel,
        building:@building,
        location: 'Locationx',
        case_id: @case_id,
        item: @item,
        quantity: @quantity
      
        message =  JSON.parse(response.body)
        expected_message = 'Location Locationx not found'
        assert_equal expected_message , message["message"][0],  "Location not found"
       
    
  end
  
  def test_validate_item
    post @url, 
        client: @client,
        warehouse: @warehouse,
        channel: @channel,
        building:@building,
        location: @location,
        case_id: @case_id,
        item: 'abcd',
        quantity: @quantity
      
        message =  JSON.parse(response.body)
        expected_message = 'Item  abcd does not exist in Itemmaster'
        assert_equal expected_message , message["message"][0],  "Item not found"
  end
  
  def test_validate_location_type
    post @url, 
        client: @client,
        warehouse: @warehouse,
        channel: @channel,
        building:@building,
        location: location_masters(:three).barcode,
        case_id: @case_id,
        item: @item,
        quantity: @quantity
      
        message =  JSON.parse(response.body)
        expected_message = 'Can not receive to a non pending Location'
        assert_equal expected_message , message["message"][0],  "Pending location"
       
    
  end
  
  def test_record_status
    post @url,
        client: @client,
        warehouse: @warehouse,
        channel: @channel,
        building:@building,
        location: location_masters(:two).barcode,
        case_id: @case_id,
        item: @item,
        quantity: @quantity
      
        message =  JSON.parse(response.body)
        expected_message = 'Can not receive to a non empty location'
        assert_equal expected_message , message["message"][0],  "Non Empty Location"
       
  end


  def test_validate_shipment
    
      url = '/shipment/Shipment2/receive'
      post url, 
        client: @client,
        warehouse: @warehouse,
        channel: @channel,
        building:@building,
        location: @location,
        case_id: @case_id,
        item: @item,
        quantity: @quantity
      
        message =  JSON.parse(response.body)
        expected_message = 'Shipment Shipment2 not found'
        assert_equal expected_message , message["message"][0],  "Shipment not found"
       
  end
  
  
  def test_validate_item
  
      
      post @url,
        client: @client,
        warehouse: @warehouse,
        channel: @channel,
        building: @building,
        shipment_nbr: @shipment_nbr,
        location: @location,
        quantity: @quantity,
        case_id: @case_id,
        item: '12346'
       
        
        message = JSON.parse(response.body)
        expected_message = 'Item 12346 not found in this shipment' 
        assert_equal expected_message , message["message"][0], "Item not found"
  end
    
  def test_duplicate_case
    
      
      post @url,
         client: @client,
         warehouse: @warehouse,
         channel: @channel,
         building: @building,
         shipment_nbr: @shipment_nbr,
         location: @location,
         quantity: @quantity,
         case_id: case_headers(:one).case_id,
         item: @item
        
         message = JSON.parse(response.body)
        expected_message = 'Case CASE1 already exists' 
        assert_equal expected_message , message["message"][0], "Case  not found"
  
  end

  def test_receive_shipment

     puts asn_details(:one).received_qty
     
    # Check the valida shipment
    post @url, 
      client: @client,
      warehouse: @warehouse,
      channel: @channel,
      building:@building,
      location: @location,
      case_id: @case_id,
      item: @item,
      quantity: @quantity
     
    assert_equal 200, status , 'Error in service'
    message =  JSON.parse(response.body)
     
    assert_equal 'Shipment received successfully' , message["message"][0],  "Service did not work"
    
    asn_header = AsnHeader.where(client: @client, warehouse: @warehouse , channel: @channel, building: @building, shipment_nbr: @shipment_nbr).first
    asn_detail = AsnDetail.where(client: @client, warehouse: @warehouse , channel: @channel, building: @building, shipment_nbr: @shipment_nbr, item: @item).first
    case_header = CaseHeader.where(client: @client, warehouse: @warehouse , channel: @channel, building: @building, case_id: @case_id).first
    location_master = LocationMaster.where(client: @client, warehouse: @warehouse , channel: @channel, building: @building, barcode: @location).first

    #Shipment
    assert_equal  asn_headers(:one).units_rcvd + @quantity , asn_header.units_rcvd , "ASN Header received quantity mismatch"
    assert_equal  asn_details(:one).received_qty + @quantity, asn_detail.received_qty , "ASN Detail received quantity mismatch"

    #Case
    assert_equal  @quantity, case_header.quantity , "Case quantity mismatch"
    assert_equal  'Yes' , case_header.on_hold , "Case put on hold"
    assert_equal  'Received' , case_header.hold_code , "On Hold Code for Case"
    
    
    
    


    assert_equal  'Occupied', location_master.record_status , "Location not getting updated"
 

  end
  

  
  
  
end
