require 'test_helper'

class ShipmentReceiveExtensionTest < ActionDispatch::IntegrationTest
 
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
    @url = '/shipment/' + asn_headers(:one).shipment_nbr + '/receive' 
    @client = 'WM'
    @warehouse = 'WH1'
    @building = nil
    @channel = nil
    @shipment_nbr = asn_headers(:one).shipment_nbr
    @location = location_masters(:one).barcode
    @case_id = 'CASE2'
    @item = asn_details(:one).item
    @quantity = 5
    @innerpack_qty = item_inner_packs(:one).innerpack_qty
    @condition = { client: @client, warehouse: @warehouse, building: @building, channel: @channel, module: 'RECEIVING' }
    @configuration = GlobalConfiguration.get_configuration(@condition)
  end  
  
  
  test "validate multiple inputs" do
    url = '/shipment/item/validate'
    post url, 
    
    shipment: {   
        client: @client,
        warehouse: @warehouse,
        channel: @channel,
        building:@building,
        location: @location,
        case_id: @case_id,
        item: 'abcd',
        quantity: @quantity
    }  
        message =  JSON.parse(response.body)
        expected_message = 'Item abcd does not exist in Itemmaster'
        assert_equal expected_message , message.errors[0].message,  "Item not found"
  end
  
end