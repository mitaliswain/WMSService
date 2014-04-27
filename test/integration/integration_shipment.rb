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
    @client = 'WM'
    @warehouse = 'WH1'
    @building = nil
    @channel = nil
    @shipment_nbr = asn_headers(:one).shipment_nbr
    @location = ''
    @case_id = 'CASE1'
    @item = '12345'
    @quantity = 2
  end  

  def test_validate_shipment
      shipment_nbr = 'Shipment2'
      post "/receive_shipment", 
        client: @client,
        warehouse: @warehouse,
        channel: @channel,
        building:@building,
        shipment_nbr: shipment_nbr,
        location: '',
        case_id: @case_id,
        item: @item,
        quantity: @quantity
      
        message =  JSON.parse(response.body)
        expected_message = 'Shipment '+  shipment_nbr + ' not found'
        assert_equal expected_message , message["message"][0],  "Shipment not found"
       
  end
  
  def test_validate_item
    
  end
    
  def test_duplicate_case
    
  end

  def test_receive_shipment

     puts asn_details(:one).received_qty
     
    # Check the valida shipment
    post "/receive_shipment", 
      client: @client,
      warehouse: @warehouse,
      channel: @channel,
      building:@building,
      shipment_nbr: @shipment_nbr,
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
