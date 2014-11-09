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


def test_the_add_shipment_header

    url = '/shipment/add_header'
    post(url,
         app_parameters:{
             client:'WM', warehouse: 'WH1', building: '', channel: ''
         },
         fields_to_update: {
             shipment_nbr: 'Shipment20'
         } )
    shipment_header = AsnHeader.find_by_shipment_nbr('Shipment20')
    assert_not_nil shipment_header, 'added shipment header'
  end
end