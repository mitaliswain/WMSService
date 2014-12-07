require 'test_helper'

class CasePutawayValidationIntegrationTest < ActionDispatch::IntegrationTest

  fixtures :case_headers
  fixtures :case_details
  fixtures :location_masters
  fixtures :item_masters
  fixtures :global_configurations

  def setup
    @url = '/shipment/' + asn_headers(:one).shipment_nbr + '/'
    @client = 'WM'
    @warehouse = 'WH1'
    @building = nil
    @channel = nil
    @location = location_masters(:putaway_one).barcode
    @case_id = 'CASE2'
    @item = asn_details(:one).item
    @condition = {client: @client, warehouse: @warehouse, building: @building, channel: @channel, module: 'RECEIVING'}
    @configuration = GlobalConfiguration.get_configuration(@condition)
  end

  def test_putaway_validation_vor_a_valid_case
    url = '/putaway/case_id/validate'
    post url,
        putaway: {
            client: @client,
            warehouse: @warehouse,
            building: @building,
            channel: @channel,
            case_id: case_headers(:case_two).case_id,
            location: 'Location1'

        }
    message = JSON.parse(response.body)
    expected_message = 'Validation Successful'
    assert_equal expected_message, message.errors[0].message, 'putaway validation'
  end

  def test_invalid_case_id_status
    url = '/putaway/case_id/validate'
    post url,
         putaway: {
             client: @client,
             warehouse: @warehouse,
             building: @building,
             channel: @channel,
             case_id: case_headers(:case_one).case_id,
             location: 'Location1'

         }
    message = JSON.parse(response.body)
    expected_message = 'Invalid case status'
    assert_equal expected_message, message.errors[0].message, 'putaway validation'
  end

  def test_invalid_case_id_not_in_case_header
    url = '/putaway/case_id/validate'
    post url,
         putaway: {
             client: @client,
             warehouse: @warehouse,
             building: @building,
             channel: @channel,
             case_id: case_headers(:case_one).case_id,
             location: 'Location1'

         }
    message = JSON.parse(response.body)
    expected_message = 'Invalid case status'
    assert_equal expected_message, message.errors[0].message, 'putaway validation'
  end


  def test_putaway_validation_location
    url = '/putaway/location/validate'
    post url,
         putaway: {
             client: @client,
             warehouse: @warehouse,
             building: @building,
             channel: @channel,
             case_id:'2014120401',
             location: @location

         }
    message = JSON.parse(response.body)
    expected_message = 'Validation Successful'
    assert_equal expected_message, message.errors[0].message, 'putaway location validation'

  end

  def test_invalid_putaway_location
    url = '/putaway/location/validate'
    post url,
         putaway: {
             client: @client,
             warehouse: @warehouse,
             building: @building,
             channel: @channel,
             case_id:'2014120401',
             location: location_masters(:one).barcode
         }
    message = JSON.parse(response.body)
    expected_message = 'Location should be Reserved type'
    assert_equal expected_message, message.errors[0].message, 'putaway location validation'

  end

  def test_valid_putaway_type
    url = '/putaway/location/validate'
    post url,
         putaway: {
             client: @client,
             warehouse: @warehouse,
             building: @building,
             channel: @channel,
             case_id: case_headers(:case_putaway_1).case_id,
             location: location_masters(:putaway_one).barcode
         }
    message = JSON.parse(response.body)
    expected_message = 'Validation Successful'
    assert_equal expected_message, message.errors[0].message, 'putaway location validation'

    post url,
         putaway: {
             client: @client,
             warehouse: @warehouse,
             building: @building,
             channel: @channel,
             case_id: case_headers(:case_putaway_2).case_id,
             location: location_masters(:putaway_one).barcode
         }
    message = JSON.parse(response.body)
    expected_message = 'Putaway type mismatch'
    assert_equal expected_message, message.errors[0].message, 'putaway location validation'


  end

end