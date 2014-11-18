require 'test_helper'

class ShipmentReceiveProcessIntegrationTest < ActionDispatch::IntegrationTest
 
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
    @case_id = 'CASE2'
    @item = asn_details(:one).item
    @quantity = 5
    @innerpack_qty = item_inner_packs(:one).innerpack_qty
    @condition = { client: @client, warehouse: @warehouse, building: @building, channel: @channel, module: 'RECEIVING' }
    @configuration = GlobalConfiguration.get_configuration(@condition)
  end  

  def test_receive_shipment_SKU

    puts asn_details(:one).received_qty
    update_old = {value: @configuration.Receiving_Type} 
    GlobalConfiguration.set_configuration({value: 'SKU'}, @condition.merge({key: 'Receiving_Type'}))
    
    case_id = Time.now.getutc.to_s 
    # Check the valida shipment
    post "#{@url}receive", 
     
     
    shipment: {  
      client: @client,
      warehouse: @warehouse,
      channel: @channel,
      building:@building,
      location: @location,
      shipment_nbr: @shipment_nbr,
      case_id: case_id,
      item: @item,
      quantity: @quantity,
      innerpack_qty: @innerpack_qty
    } 
    assert_equal 201, status , 'message in service'
    message =  JSON.parse(response.body)
    assert_equal 'Shipment1 Received Successfully' , message.message,  "Shipment received successfully"

    asn_header = AsnHeader.where(client: @client, warehouse: @warehouse , channel: @channel, building: @building, shipment_nbr: @shipment_nbr).first
    asn_detail = AsnDetail.where(client: @client, warehouse: @warehouse , channel: @channel, building: @building, shipment_nbr: @shipment_nbr, item: @item).first
    case_header = CaseHeader.where(client: @client, warehouse: @warehouse , channel: @channel, building: @building, case_id: case_id).first
    case_detail = CaseDetail.where(client: @client, warehouse: @warehouse , channel: @channel, building: @building, case_id: case_id, item: @item).first
    location_master = LocationMaster.where(client: @client, warehouse: @warehouse , channel: @channel, building: @building, barcode: @location).first

    #Shipment
    assert_equal  asn_headers(:one).units_rcvd + @quantity , asn_header.units_rcvd , "ASN Header received quantity mismatch"
    assert_equal  asn_details(:one).received_qty + @quantity, asn_detail.received_qty , "ASN Detail received quantity mismatch"

    #Case
    assert_equal  @quantity, case_detail.quantity , "Case quantity mismatch"
    
    assert_equal  case_id, case_header.case_id , "Case created"
    assert_equal  'Yes' , case_header.on_hold , "Case put on hold"
    assert_equal  'Putaway Required' , case_header.hold_code , "On Hold Code for Case"
   
    #assert_equal  'Occupied', location_master.record_status , "Location not getting updated"
 
    GlobalConfiguration.set_configuration(update_old, @condition.merge({key: 'Receiving_Type'}))

  end

  def test_receive_shipment_Case

    update_old = {value: @configuration.Receiving_Type} 
    GlobalConfiguration.set_configuration({value: 'Case'}, @condition.merge({key: 'Receiving_Type'}))

    asn_header_old = AsnHeader.where(client: @client, warehouse: @warehouse , channel: @channel, building: @building, shipment_nbr: @shipment_nbr).first
    asn_detail_old = AsnDetail.where(client: @client, warehouse: @warehouse , channel: @channel, building: @building, shipment_nbr: @shipment_nbr, item: @item).first
    case_header_old = CaseHeader.where(client: @client, warehouse: @warehouse , channel: @channel, building: @building, case_id: @case_id).first
    case_detail_old = CaseDetail.where(client: @client, warehouse: @warehouse , channel: @channel, building: @building, case_id: @case_id, item: @item).first


    # Check the valida shipment
    post "#{@url}receive", 
      
    shipment: {  
      client: @client,
      warehouse: @warehouse,
      channel: @channel,
      building:@building,
      location: @location,
      shipment_nbr: @shipment_nbr,
      case_id: case_headers(:case_four).case_id,
      item: case_details(:case_four).item,
      quantity: case_details(:case_four).quantity,
      innerpack_qty: @innerpack_qty
    } 
    message =  JSON.parse(response.body)
    assert_equal 201, status , 'message in service'
    assert_equal 'Shipment1 Received Successfully' , message.message,  "Shipment received successfully"
    
    asn_header = AsnHeader.where(client: @client, warehouse: @warehouse , channel: @channel, building: @building, shipment_nbr: @shipment_nbr).first
    asn_detail = AsnDetail.where(client: @client, warehouse: @warehouse , channel: @channel, building: @building, shipment_nbr: @shipment_nbr, item: @item).first
    case_header = CaseHeader.where(client: @client, warehouse: @warehouse , channel: @channel, building: @building, case_id: case_headers(:case_four).case_id).first
    case_detail = CaseDetail.where(client: @client, warehouse: @warehouse , channel: @channel, building: @building, case_id: case_headers(:case_four).case_id, item: case_details(:case_four).item).first
    location_master = LocationMaster.where(client: @client, warehouse: @warehouse , channel: @channel, building: @building, barcode: @location).first

    #Shipment
    assert_equal  asn_header_old.units_rcvd + 10 , asn_header.units_rcvd , "ASN Header received quantity mismatch"
    assert_equal  asn_detail_old.received_qty+ 10, asn_detail.received_qty , "ASN Detail received quantity mismatch"

    #Case
    assert_equal  'Received', case_header.record_status , "Case received"        
    assert_equal  'Yes' , case_header.on_hold , "Case put on hold"
    assert_equal  'Putaway Required' , case_header.hold_code , "On Hold Code for Case"
    assert_equal  'Received' , case_detail.record_status , "Case detail udated"
   
   
   
    #assert_equal  'Occupied', location_master.record_status , "Location not getting updated"
 
    GlobalConfiguration.set_configuration(update_old, @condition.merge({key: 'Receiving_Type'}))

  end
  

  def test_item_innerpack_exists_SKU

     #puts asn_details(:one).received_qty
      update_old = {value: @configuration.Receiving_Type} 
      GlobalConfiguration.set_configuration({value: 'SKU'}, @condition.merge({key: 'Receiving_Type'}))
     
    # Check the valida shipment
    post "#{@url}receive", 
     
    shipment: { 
      client: @client,
      warehouse: @warehouse,
      channel: @channel,
      building:@building,
      location: @location,
      shipment_nbr: @shipment_nbr,
      case_id: Time.now.getutc,
      item: @item,
      quantity: @quantity,
      innerpack_qty: @innerpack_qty
     }
    assert_equal 201, status , 'success message'
    
    message =  JSON.parse(response.body)
     
    assert_equal 'Shipment1 Received Successfully' , message.message,  "Shipment received successfully"
    item_inner_packs = ItemInnerPack.where(client: @client, item: @item)
    assert_equal  1, item_inner_packs.length , "Received with existing innerpack"
    GlobalConfiguration.set_configuration(update_old, @condition.merge({key: 'Receiving_Type'}))
  
    end


    
  def test_item_innerpack_not_exist_SKU

    #puts asn_details(:one).received_qty
    update_old = {value: @configuration.Receiving_Type} 
    GlobalConfiguration.set_configuration({value: 'SKU'}, @condition.merge({key: 'Receiving_Type'}))
     
    # Check the valida shipment
    post "#{@url}receive", 
  
    shipment: {
      client: @client,
      warehouse: @warehouse,
      channel: @channel,
      building:@building,
      location: @location,
      shipment_nbr: @shipment_nbr,
      case_id: Time.now.getutc,
      item: asn_details(:two).item,
      quantity: @quantity,
      innerpack_qty: @innerpack_qty + 10
    } 
    assert_equal 201, status , 'Successfully Created'
    message =  JSON.parse(response.body)
     
    assert_equal 'Shipment1 Received Successfully' , message.message,  "Shipment received successfully"
    item_inner_packs = ItemInnerPack.where(client: @client, item: asn_details(:two).item).order(:id)
    assert_equal  2, item_inner_packs.length , "Received with non existing innerpack"
    assert_equal  @innerpack_qty + 10, item_inner_packs[1].innerpack_qty , "New innerpack "
    
    GlobalConfiguration.set_configuration(update_old, @condition.merge({key: 'Receiving_Type'}))
  
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
        building:@building,
        location: @location,
        shipment_nbr: asn_headers(:duplicate_line).shipment_nbr,
        case_id: '@case2',
        item: asn_details(:duplicate_line_1).item,
        quantity: asn_details(:duplicate_line_1).shipped_quantity,
        innerpack_qty: @innerpack_qty
     }    

     asn_detail = AsnDetail.where(client: @client, warehouse: @warehouse , channel: @channel, building: @building, shipment_nbr: asn_headers(:duplicate_line).shipment_nbr, poline_nbr: 1).first
     case_detail = CaseDetail.where(client: @client, warehouse: @warehouse , channel: @channel, building: @building, case_id: '@case2').first
     assert_equal  asn_details(:duplicate_line_1).shipped_quantity , asn_detail.received_qty , "Received desired quantity"
     assert_equal  asn_details(:duplicate_line_1).poline_nbr, case_detail.poline_nbr, "Received against correct po line number"

     
     url = "/shipment/#{asn_headers(:duplicate_line).shipment_nbr}/receive"
    post url, 
  #first receiving with all quantity in first line 
    shipment: {
        client: @client,
        warehouse: @warehouse,
        channel: @channel,
        building:@building,
        location: @location,
        shipment_nbr: asn_headers(:duplicate_line).shipment_nbr,
        case_id: '@case3',
        item: asn_details(:duplicate_line_2).item,
        quantity: asn_details(:duplicate_line_2).shipped_quantity,
        innerpack_qty: @innerpack_qty
     }         
    
     asn_detail = AsnDetail.where(client: @client, warehouse: @warehouse , channel: @channel, building: @building, shipment_nbr: asn_headers(:duplicate_line).shipment_nbr, poline_nbr: 2).first
     case_detail = CaseDetail.where(client: @client, warehouse: @warehouse , channel: @channel, building: @building, case_id: '@case3').first
     assert_equal  asn_details(:duplicate_line_2).shipped_quantity , asn_detail.received_qty , "Received desired quantity"
     assert_equal  asn_details(:duplicate_line_2).poline_nbr, case_detail.poline_nbr, "Received against correct po line number"
  end


    
 end
 