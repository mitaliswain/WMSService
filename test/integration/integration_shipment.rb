require 'test_helper'

class ReceiveShipmentControllerTest < ActionDispatch::IntegrationTest
 
fixtures :asn_details
fixtures :asn_headers
fixtures :case_headers
fixtures :case_details

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
        location: 'Location1',
        case_id: @case_id,
        item: @item,
        quantity: @quantity
      
        message =  JSON.parse(response.body)
        expected_message = 'Location Location1 not Exists'
        assert_equal expected_message , message["message"][0],  "Location not found"
       
    
  end


  def test_validate_shipment
    
      url = '/shipment/Shipment2/receive'
      post url, 
        client: @client,
        warehouse: @warehouse,
        channel: @channel,
        building:@building,
        location: '',
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
      location: '',
      case_id: @case_id,
      item: @item,
      quantity: @quantity
     
    assert_equal 200, status , 'Error in service'
    message =  JSON.parse(response.body)
     
    assert_equal 'Shipment received successfully' , message["message"][0],  "Service did not work"
    
    asn_header = AsnHeader.where(client: @client, warehouse: @warehouse , channel: @channel, building: @building, shipment_nbr: @shipment_nbr).first
    asn_detail = AsnDetail.where(client: @client, warehouse: @warehouse , channel: @channel, building: @building, shipment_nbr: @shipment_nbr, item: @item).first
    case_header = CaseHeader.where(client: @client, warehouse: @warehouse , channel: @channel, building: @building, case_id: @case_id).first

    assert_equal  asn_headers(:one).units_rcvd + @quantity , asn_header.units_rcvd , "ASN Header received quantity mismatch"
    assert_equal  asn_details(:one).received_qty + @quantity, asn_detail.received_qty , "ASN Detail received quantity mismatch"
    assert_equal  @quantity, case_header.quantity , "Case quantity mismatch"
 

  end
  

  
  
  
end
