require 'test_helper'

class ShipmentReceiveValidationIntegrationTest < ActionDispatch::IntegrationTest

  fixtures :asn_details
  fixtures :asn_headers
  fixtures :case_headers
  fixtures :case_details
  fixtures :location_masters
  fixtures :item_masters
  fixtures :global_configurations
  fixtures :item_inner_packs
  fixtures :serial_numbers

  # test "the truth" do
  #   assert true
  # end

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

  def test_location_not_found_if_yard_managment_is_true
    GlobalConfiguration.set_configuration({value: 't'}, @condition.merge({key: 'Yard_Management'}))
    url = '/shipment/location/validate'
    post url,

         shipment: {
             client: @client,
             warehouse: @warehouse,
             channel: @channel,
             building: @building,
             shipment_nbr: asn_headers(:one).shipment_nbr,
             location: 'Locationx',
             case_id: @case_id,
             item: @item,
             quantity: @quantity
         }
    expected_message = ''
    message = JSON.parse(response.body)
    expected_message = 'Location Locationx not found'
    assert_equal expected_message, message.errors[0].message, "Location not found"
  end

  def test_location_not_found
    url = '/shipment/location/validate'
    post url,

         shipment: {
             client: @client,
             warehouse: @warehouse,
             channel: @channel,
             building: @building,
             shipment_nbr: asn_headers(:one).shipment_nbr,
             location: 'Locationx',
             case_id: @case_id,
             item: @item,
             quantity: @quantity
         }
    message = JSON.parse(response.body)
    expected_status = '422'
    assert_equal expected_status, message.status, "Location not found"
  end

  def test_validate_location_type
    url = '/shipment/location/validate'
    post url,

         shipment: {
             client: @client,
             warehouse: @warehouse,
             channel: @channel,
             building: @building,
             shipment_nbr: asn_headers(:two).shipment_nbr,
             location: location_masters(:two).barcode,
             case_id: @case_id,
             item: @item,
             quantity: @quantity
         }
    message = JSON.parse(response.body)
    expected_message = "Location #{location_masters(:two).barcode} is not valid receiving location"
    assert_equal expected_message, message.errors[0].message, "Non receiving Location"
  end

  def test_validate_location_type
    url = '/shipment/location/validate'
    post url,

         shipment: {
             client: @client,
             warehouse: @warehouse,
             channel: @channel,
             building: @building,
             location: location_masters(:three).barcode,
             case_id: @case_id,
             item: @item,
             quantity: @quantity
         }
    message = JSON.parse(response.body)
    expected_message = "Location #{location_masters(:three).barcode} is not valid receiving location"
    assert_equal expected_message, message.errors[0].message, "Pending location"

  end


  def test_validate_shipment_exist

    url = '/shipment/shipment_nbr/validate'
    post url,

         shipment: {
             client: @client,
             warehouse: @warehouse,
             channel: @channel,
             building: @building,
             location: @location,
             case_id: @case_id,
             item: @item,
             quantity: @quantity,
             shipment_nbr: 'Shipment2x'
         }
    message = JSON.parse(response.body)
    expected_message = 'Shipment Shipment2x not found'
    assert_equal expected_message, message.errors[0].message, "Shipment not found"

  end

  def test_validate_shipment_record_status
    url = '/shipment/shipment_nbr/validate'
    post url,

         shipment: {
             client: @client,
             warehouse: @warehouse,
             channel: @channel,
             building: @building,
             shipment_nbr: asn_headers(:three).shipment_nbr,
             location: location_masters(:four).barcode,
             case_id: @case_id,
             item: @item,
             quantity: @quantity
         }
    message = JSON.parse(response.body)
    expected_message = "Shipment #{asn_headers(:three).shipment_nbr} not initiated"
    assert_equal expected_message, message.errors[0].message, "Validate shipment record status"

  end

  def test_validate_if_the_shipment_is_received_to_pre_define_dock_door
    url = '/shipment/shipment_nbr/validate'
    GlobalConfiguration.set_configuration({value: 't'}, @condition.merge({key: 'Yard_Management'}))
    post url,

         shipment: {
             client: @client,
             warehouse: @warehouse,
             channel: @channel,
             building: @building,
             shipment_nbr: asn_headers(:two).shipment_nbr,
             location: nil,
             case_id: @case_id,
             item: @item,
             quantity: @quantity
         }
    message = JSON.parse(response.body)
    expected_message = 'Shipment Shipment2 not assigned to this Dock Door'
    assert_equal expected_message, message.errors[0].message, "Shipment not received at incorrect Location"
  end

  def test_case_case_not_entered

    url = '/shipment/case/validate'

    post url,

         shipment: {
             client: @client,
             warehouse: @warehouse,
             channel: @channel,
             building: @building,
             shipment_nbr: @shipment_nbr,
             location: @location,
             quantity: @quantity,
             case_id: nil,
             item: @item
         }
    message = JSON.parse(response.body)
    expected_message = 'Enter Case'
    assert_equal expected_message, message.errors[0].message, "Case not Entered"
  end

  def test_case_not_received_case

    url = '/shipment/case/validate'
    update_old = {value: @configuration.Receiving_Type}
    GlobalConfiguration.set_configuration({value: 'Case'}, @condition.merge({key: 'Receiving_Type'}))

    post url,
         shipment: {
             client: @client,
             warehouse: @warehouse,
             channel: @channel,
             building: @building,
             shipment_nbr: @shipment_nbr,
             location: @location,
             quantity: @quantity,
             case_id: '@Case1x',
             item: @item
         }
    message = JSON.parse(response.body)
    expected_message = 'Case @Case1x does not exist'
    assert_equal expected_message, message.errors[0].message, "Case not found"
    GlobalConfiguration.set_configuration({value: 'SKU'}, @condition.merge({key: 'Receiving_Type'}))

  end

  def test_case_received_invalid_status_case

    url = '/shipment/case/validate'
    update_old = {value: @configuration.Receiving_Type}
    GlobalConfiguration.set_configuration({value: 'Case'}, @condition.merge({key: 'Receiving_Type'}))
    post url,

         shipment: {
             client: @client,
             warehouse: @warehouse,
             channel: @channel,
             building: @building,
             shipment_nbr: @shipment_nbr,
             location: @location,
             quantity: @quantity,
             case_id: case_headers(:case_two).case_id,
             item: @item
         }
    message = JSON.parse(response.body)
    expected_message = "Case #{case_headers(:case_two).case_id} already received"
    assert_equal expected_message, message.errors[0].message, "Case already received"
    GlobalConfiguration.set_configuration({value: 'SKU'}, @condition.merge({key: 'Receiving_Type'}))

  end

  def test_duplicate_case_SKU
    update_old = {value: @configuration.Receiving_Type}
    GlobalConfiguration.set_configuration({value: 'SKU'}, @condition.merge({key: 'Receiving_Type'}))
    url = '/shipment/case/validate'

    post url,

         shipment: {
             client: @client,
             warehouse: @warehouse,
             channel: @channel,
             building: @building,
             shipment_nbr: @shipment_nbr,
             location: @location,
             quantity: @quantity,
             case_id: case_headers(:one).case_id,
             item: @item
         }
    message = JSON.parse(response.body)
    expected_message = 'Case '+ case_headers(:one).case_id + ' already exists'
    assert_equal expected_message, message.errors[0].message, "Case  not found"
    GlobalConfiguration.set_configuration(update_old, @condition.merge({key: 'Receiving_Type'}))

  end

  def test_valid_case_for_case_receiving
    GlobalConfiguration.set_configuration({value: 'Case'}, @condition.merge({key: 'Receiving_Type'}))
    url = '/shipment/case/validate'

    post url,

         shipment: {
             client: @client,
             warehouse: @warehouse,
             channel: @channel,
             building: @building,
             shipment_nbr: @shipment_nbr,
             location: @location,
             quantity: @quantity,
             case_id: case_headers(:one).case_id,
             item: @item
         }
    message = JSON.parse(response.body)
    expected_message = {'case_id' => case_details(:one).case_id, 'item' => case_details(:one).item, 'quantity' => case_details(:one).quantity}
    #expected_message = 'Enter Case'
    assert_equal expected_message, message['additional_info'][0], "Case not Entered"
  end

  def test_validate_item_not_in_itemmaster

    url = '/shipment/item/validate'
    post url,

         shipment: {
             client: @client,
             warehouse: @warehouse,
             channel: @channel,
             building: @building,
             shipment_nbr: @shipment,
             location: @location,
             case_id: @case_id,
             item: 'abcd',
             quantity: @quantity
         }
    message = JSON.parse(response.body)
    expected_message = 'Item abcd does not exist in Itemmaster'
    assert_equal expected_message, message.errors[0].message, "Item not found"
  end

  def test_validate_item_not_in_shipment

    url = '/shipment/item/validate'
    post url,

         shipment: {
             client: @client,
             warehouse: @warehouse,
             channel: @channel,
             building: @building,
             shipment_nbr: @shipment_nbr,
             location: @location,
             quantity: @quantity,
             case_id: @case_id,
             item: '123467'
         }

    message = JSON.parse(response.body)
    expected_message = 'Item 123467 not found in this shipment'
    assert_equal expected_message, message.errors[0].message, "Item not found"
  end

  def test_validate_item_in_case

    update_old = {value: @configuration.Receiving_Type}
    GlobalConfiguration.set_configuration({value: 'Case'}, @condition.merge({key: 'Receiving_Type'}))

    url = '/shipment/item/validate'
    post url,

         shipment: {
             client: @client,
             warehouse: @warehouse,
             channel: @channel,
             building: @building,
             location: @location,
             shipment_nbr: @shipment_nbr,
             case_id: case_headers(:case_one).case_id,
             item: '1234678',
             quantity: @quantity
         }
    message = JSON.parse(response.body)
    expected_message = 'Item 1234678 is not associated to this Case'
    assert_equal expected_message, message.errors[0].message, "Item not found in Case"
  end

  def test_validate_quantity_in_case

    update_old = {value: @configuration.Receiving_Type}
    GlobalConfiguration.set_configuration({value: 'Case'}, @condition.merge({key: 'Receiving_Type'}))

    url = '/shipment/quantity/validate'
    post url,
         shipment: {
             client: @client,
             warehouse: @warehouse,
             channel: @channel,
             building: @building,
             location: @location,
             shipment_nbr: @shipment_nbr,
             case_id: case_headers(:case_three).case_id,
             item: case_details(:case_three).item,
             quantity: case_details(:case_three).quantity + 1
         }
    message = JSON.parse(response.body)
    expected_message = 'Quantity entered does not match with the qty on the case'
    assert_equal expected_message, message.errors[0].message, "Quantity mismatch"
  end

  def test_validate_quantity_for_SKU_receiving

    update_old = {value: @configuration.Receiving_Type}
    GlobalConfiguration.set_configuration({value: 'SKU'}, @condition.merge({key: 'Receiving_Type'}))

    url = '/shipment/quantity/validate'
    post url,

         shipment: {
             client: @client,
             warehouse: @warehouse,
             channel: @channel,
             building: @building,
             location: @location,
             shipment_nbr: @shipment_nbr,
             case_id: '@case1',
             item: asn_details(:one).item,
             quantity: asn_details(:one).shipped_quantity - asn_details(:one).received_qty + 1
         }
    message = JSON.parse(response.body)
    expected_message = 'Quantity received exceeds shipped quantity'
    assert_equal expected_message, message.errors[0].message, "Quantity mismatch in SKU"
  end

  def test_validation_for_duplicate_po_item_in_same_shipment

    GlobalConfiguration.set_configuration({value: 'SKU'}, @condition.merge({key: 'Receiving_Type'}))

    url = "/shipment/#{asn_headers(:duplicate_line).shipment_nbr}/receive"
    post url,
         #first receiving with all quantity in first line
         shipment: {
             client: @client,
             warehouse: @warehouse,
             channel: @channel,
             building: @building,
             location: @location,
             shipment_nbr: asn_headers(:duplicate_line).shipment_nbr,
             case_id: '@case2',
             item: asn_details(:duplicate_line_1).item,
             quantity: asn_details(:duplicate_line_1).shipped_quantity,
             innerpack_qty: @innerpack_qty
         }

    url = "/shipment/quantity/validate"
    post url,
         shipment: {
             client: @client,
             warehouse: @warehouse,
             channel: @channel,
             building: @building,
             location: @location,
             shipment_nbr: asn_headers(:duplicate_line).shipment_nbr,
             case_id: '@case3',
             item: asn_details(:duplicate_line_2).item,
             quantity: asn_details(:duplicate_line_2).shipped_quantity.to_i + 1
         }


    message = JSON.parse(response.body)
    expected_status = 422
    assert_equal expected_status, status, "Received successfully for duplicate po item"
  end

  def test_validate_serial_number_total_quantity_entered

    update_old = {value: @configuration.Receiving_Type}
    GlobalConfiguration.set_configuration({value: 'SKU'}, @condition.merge({key: 'Receiving_Type'}))

    shipment_hash =
        {
            client: @client,
            warehouse: @warehouse,
            channel: @channel,
            building: @building,
            location: @location,
            shipment_nbr: @shipment_nbr,
            case_id: Time.now.getutc.to_s,
            item: item_masters(:one).item,
            quantity: 4,
            serial_nbr: ['1']
        }

    url = '/shipment/serial_nbr/validate'
    post url, shipment: shipment_hash
    message = JSON.parse(response.body)
    expected_message = 'Scan the next serial number'
    assert_equal expected_message, message.errors[0].message, 'Scan the next serial number'

    shipment_hash[:serial_nbr] << '2'
    post url, shipment: shipment_hash
    message = JSON.parse(response.body)
    expected_message = 'Scan the next serial number'
    assert_equal expected_message, message.errors[0].message, 'Scan the next serial number'

    shipment_hash[:serial_nbr] << '2'
    post url, shipment: shipment_hash
    message = JSON.parse(response.body)
    assert_equal 'Scan the next serial number', message.errors[0].message, 'Scan the next serial number'
    assert_equal 'Serial number already exists', message.errors[1].message, 'Serial number already exists'
    shipment_hash[:serial_nbr].delete_at(2)

    shipment_hash[:serial_nbr] << '3'
    post url, shipment: shipment_hash
    message = JSON.parse(response.body)
    expected_message = 'Scan the next serial number'
    assert_equal expected_message, message.errors[0].message, 'Scan the next serial number'


    shipment_hash[:serial_nbr] << '4'
    post url, shipment: shipment_hash
    message = JSON.parse(response.body)
    expected_message = 'Validation Successful'
    assert_equal expected_message, message.errors[0].message, 'Scan the next serial number'

  end

  def test_validate_serial_number_existing_serial_number

    update_old = {value: @configuration.Receiving_Type}
    GlobalConfiguration.set_configuration({value: 'SKU'}, @condition.merge({key: 'Receiving_Type'}))

    shipment_hash =
        {
            client: @client,
            warehouse: @warehouse,
            channel: @channel,
            building: @building,
            location: @location,
            shipment_nbr: @shipment_nbr,
            case_id: Time.now.getutc.to_s,
            item: item_masters(:one).item,
            quantity: 3,
            serial_nbr: [serial_numbers(:one).serial_nbr]
        }

    url = '/shipment/serial_nbr/validate'
    post url, shipment: shipment_hash
    message = JSON.parse(response.body)
    assert_equal 'Scan the next serial number', message.errors[0].message, 'Scan the next serial number'
    assert_equal 'Serial number already exists', message.errors[1].message, 'Serial number already exists'

  end

end