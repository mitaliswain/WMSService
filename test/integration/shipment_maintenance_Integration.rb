require 'test_helper'

class ShipmentReceiveIntegrationTest < ActionDispatch::IntegrationTest
 
fixtures :asn_details
fixtures :asn_headers
fixtures :case_headers
fixtures :case_details
fixtures :location_masters
fixtures :item_masters
fixtures :global_configurations
fixtures :item_inner_packs


  def test_the_update_of_single_field
    shipment = AsnHeader.where(shipment_nbr: asn_headers(:two).shipment_nbr).first
    url = "/shipment/#{shipment.id}/update_header"
    message = post(url, 
    app_parameters:{
      client:'WM', warehouse: 'WH1', building: '', channel: ''
    },  
    fields_to_update: {
        door_door: shipment.door_door + 'x'
        }) 
    shipment_updated = AsnHeader.where(shipment_nbr: asn_headers(:two).shipment_nbr).first
    assert_equal 201, status, 'Updated shipment status'
    assert_equal shipment.door_door + 'x', shipment_updated.door_door, 'Updated shipment data'
    
  end



end