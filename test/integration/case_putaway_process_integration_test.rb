require 'test_helper'

class CasePutawayProcessingIntegrationTest < ActionDispatch::IntegrationTest

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
    @shipment_nbr = asn_headers(:one).shipment_nbr
    @location = location_masters(:one).barcode
    @case_id = 'CASE2'
    @item = asn_details(:one).item
    @quantity = 5
    @innerpack_qty = item_inner_packs(:one).innerpack_qty
    @condition = {client: @client, warehouse: @warehouse, building: @building, channel: @channel, module: 'RECEIVING'}
    @configuration = GlobalConfiguration.get_configuration(@condition)
  end

  def test_putaway_process_vor_a_valid_case
    url = '/putaway/2014120401/putaway'
    post url,
         putaway: {
             client: @client,
             warehouse: @warehouse,
             building: @building,
             channel: @channel,
             case_id:'2014120401',
             location: 'Location1'

         }
    message = JSON.parse(response.body)
    expected_message = 'Validation Successful'
    assert_equal  '2014120401 putaway done successfully for the case', message.message, "processing putaway"



  end

end