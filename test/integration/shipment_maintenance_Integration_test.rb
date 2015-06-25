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

      #Error for duplicate header
      url = '/shipment/add_header'
      post(url,
           app_parameters:{
               client:'WM', warehouse: 'WH1', building: '', channel: ''
           },
           fields_to_update: {
               shipment_nbr: 'Shipment20'
           } )
      assert_equal 'Validation failed: Shipment nbr has already been taken', JSON.parse(response.body)['message'], 'added shipment header'

  end

  def test_the_update_shipment_header
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

def test_the_add_shipment_detail
  shipment = AsnHeader.where(shipment_nbr: asn_headers(:two).shipment_nbr).first
  number_of_shipment_detail_before_test = AsnDetail.where(shipment_nbr: asn_headers(:two).shipment_nbr).size
  url = '/shipment/add_detail'
  post(url,
       app_parameters:{
           client:'WM', warehouse: 'WH1', building: '', channel: ''
       },
       fields_to_update: {
           asn_header_id: shipment.id,
           shipment_nbr: 'Shipment20',
           item: item_masters(:one).item,
           shipped_quantity: 10,
           received_qty: 0
       } )
  number_of_shipment_detail_after_test = AsnDetail.where(shipment_nbr: asn_headers(:two).shipment_nbr).size
  assert_equal(number_of_shipment_detail_before_test + 1, number_of_shipment_detail_after_test, 'added shipment detail')
end


end