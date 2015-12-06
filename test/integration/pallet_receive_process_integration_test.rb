require 'test_helper'

class PalletReceiveProcessIntegrationTest < ActionDispatch::IntegrationTest

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
    @url = '/shipment/' + asn_headers(:one).shipment_nbr + '/'
    @client = 'WM'
    @warehouse = 'WH1'
    @building = nil
    @channel = nil
    @shipment_nbr = asn_headers(:one).shipment_nbr
    @location = location_masters(:one).barcode
    @pallet_id = 'PALLET1'
    @condition = {client: @client, warehouse: @warehouse, building: @building, channel: @channel, module: 'RECEIVING'}
    @configuration = GlobalConfiguration.get_configuration(@condition)
  end

=begin
  def test_receive_pallet
    update_old = {value: @configuration.Receiving_Type}
    GlobalConfiguration.set_configuration({value: 'Case'}, @condition.merge({key: 'Receiving_Type'}))


    # Check the valida shipment
    post "#{@url}receive",


         shipment: {
             receiving_type: 'Pallet',
             client: @client,
             warehouse: @warehouse,
             channel: @channel,
             building: @building,
             location: @location,
             shipment_nbr: @shipment_nbr,
             pallet: @pallet_id,
             innerpack_qty: 1
         }

    assert_equal 201, status, 'message in service'
    message = JSON.parse(response.body)
    assert_equal "#{@pallet_id} Received Successfully", message.message, "Pallet received successfully"

    cases = CaseHeader.where(pallet_id: @pallet_id)
    cases.each do |cs|
      assert_equal 'Received', cs.record_status, "Pallet received successfully"
    end

    GlobalConfiguration.set_configuration(update_old, @condition.merge({key: 'Receiving_Type'}))

  end
=end

  def test_reject_receive_pallet_if_any_of_the_case_is_invalid
    update_old = {value: @configuration.Receiving_Type}
    GlobalConfiguration.set_configuration({value: 'Case'}, @condition.merge({key: 'Receiving_Type'}))

    cases = CaseHeader.where(pallet_id: @pallet_id).last
    case_id = cases.case_id
    cases.record_status = 'Received'
    cases.save!

    # Check the valida shipment
    post "#{@url}receive",


         shipment: {
             receiving_type: 'Pallet',
             client: @client,
             warehouse: @warehouse,
             channel: @channel,
             building: @building,
             location: @location,
             shipment_nbr: @shipment_nbr,
             pallet: @pallet_id,
             innerpack_qty: 1
         }

    assert_equal 201, status, 'message in service'
    message = JSON.parse(response.body)
    p message
    assert_equal "#{@pallet_id} Received Successfully", message.message, "Shipment received successfully"

    cases = CaseHeader.where(pallet_id: @pallet_id)
    cases.each do |cs|
      assert_equal 'Created', cs.record_status, "Pallet rejected successfully" if cs.case_id != case_id
    end

    GlobalConfiguration.set_configuration(update_old, @condition.merge({key: 'Receiving_Type'}))

  end


end
 