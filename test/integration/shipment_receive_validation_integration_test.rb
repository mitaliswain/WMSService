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

  def test_location_not_found_if_yard_managment_is_true
    GlobalConfiguration.set_configuration({value: 't'}, @condition.merge({key: 'Yard_Management'}))
    url = '/shipment/location/validate'
    post url, 
    
    shipment: {
        client: @client,
        warehouse: @warehouse,
        channel: @channel,
        building:@building,
        shipment_nbr: asn_headers(:one).shipment_nbr,
        location: 'Locationx',
        case_id: @case_id,
        item: @item,
        quantity: @quantity
        } 
       expected_message = '' 
       message =  JSON.parse(response.body)
       expected_message = 'Location Locationx not found'          
       assert_equal expected_message , message.errors[0].message,  "Location not found" 
  end
  
  def test_location_not_found_if_yard_managment_is_false
    GlobalConfiguration.set_configuration({value: 'f'}, @condition.merge({key: 'Yard_Management'}))
    url = '/shipment/location/validate'
    post url, 
    
    shipment: {
        client: @client,
        warehouse: @warehouse,
        channel: @channel,
        building:@building,
        shipment_nbr: asn_headers(:one).shipment_nbr,
        location: 'Locationx',
        case_id: @case_id,
        item: @item,
        quantity: @quantity
        } 
       message =  JSON.parse(response.body)
       expected_status = '200'      
       assert_equal expected_status , message.status,  "Location not found"    
  end

  def test_validate_location_type
    GlobalConfiguration.set_configuration({value: 't'}, @condition.merge({key: 'Yard_Management'}))
    url = '/shipment/location/validate'
    post url,
      
      shipment: {
        client: @client,
        warehouse: @warehouse,
        channel: @channel,
        building:@building,
        shipment_nbr: asn_headers(:two).shipment_nbr,
        location: location_masters(:two).barcode,
        case_id: @case_id,
        item: @item,
        quantity: @quantity
      }
      message =  JSON.parse(response.body)
      expected_message = "Location #{location_masters(:two).barcode} is not valid receiving location"
      assert_equal expected_message , message.errors[0].message,  "Non receiving Location"      
  end
  
  def test_validate_dock_door_status
    GlobalConfiguration.set_configuration({value: 't'}, @condition.merge({key: 'Yard_Management'}))
    url  = '/shipment/location/validate'
    post url,
    
      shipment: { 
        client: @client,
        warehouse: @warehouse,
        channel: @channel,
        building:@building,
        shipment_nbr: asn_headers(:two).shipment_nbr ,
        location: location_masters(:four).barcode,
        case_id: @case_id,
        item: @item,
        quantity: @quantity
      }
       message =  JSON.parse(response.body)
       expected_message = 'Dock Door occupied by another shipment'
       assert_equal expected_message , message.errors[0].message,  "Validate Non Empty dock door"   
  end

  def test_validate_dock_door_status_when_shipment_is_not_givens
    GlobalConfiguration.set_configuration({value: 't'}, @condition.merge({key: 'Yard_Management'}))
    url  = '/shipment/location/validate'
    post url,
    
      shipment: { 
        client: @client,
        warehouse: @warehouse,
        channel: @channel,
        building:@building,
        shipment_nbr: nil ,
        location: location_masters(:four).barcode,
        case_id: @case_id,
        item: @item,
        quantity: @quantity
      }
       message =  JSON.parse(response.body)
       expected_status = '200'
       assert_equal expected_status , message.status,  "Validate Non Empty dock door when shipment not entered"   
  end

  def test_no_validaiton_for_no_Yard_Management
    GlobalConfiguration.set_configuration({value: 'f'}, @condition.merge({key: 'Yard_Management'}))
    url  = '/shipment/location/validate'
    post url,
    
      shipment: { 
        client: @client,
        warehouse: @warehouse,
        channel: @channel,
        building:@building,
        shipment_nbr: asn_headers(:two).shipment_nbr ,
        location: location_masters(:four).barcode,
        case_id: @case_id,
        item: @item,
        quantity: @quantity
      }
       message =  JSON.parse(response.body)
       expected_status = '200'
       assert_equal expected_status , message.status,  "No validation of shipment for no yard management"   
  end
  
  
  def test_validate_shipment_number_and_dock_door
    GlobalConfiguration.set_configuration({value: 't'}, @condition.merge({key: 'Yard_Management'}))
    url = '/shipment/shipment_nbr/validate'
    post url, 
    
    shipment: {    
        client: @client,
        warehouse: @warehouse,
        channel: @channel,
        building: @building,
        location: location_masters(:four).barcode,
        shipment_nbr: asn_headers(:two).shipment_nbr ,
        case_id: @case_id,
        item: @item,
        quantity: @quantity
    }
       message =  JSON.parse(response.body)
       expected_message = 'Shipment ' + asn_headers(:two).shipment_nbr + ' not assigned to this Dock Door'
       assert_equal expected_message , message.errors[0].message,  "Validate Shipment to the assigned dock door"
    
  end
  
  
  def test_validate_location_type
    url = '/shipment/location/validate'
    post url, 
     
    shipment: { 
        client: @client,
        warehouse: @warehouse,
        channel: @channel,
        building:@building,
        location: location_masters(:three).barcode,
        case_id: @case_id,
        item: @item,
        quantity: @quantity
     } 
        message =  JSON.parse(response.body)
        if @configuration.Yard_Management == "t"
            expected_message = 'Can not receive to a non pending Location'
             assert_equal expected_message , message.status, "Pending location"
        else    
            expected_status = '200'   
             assert_equal expected_status , message.status, "Pending location"
        end
       
  end
  

  def test_validate_shipment_exist
    
      url = '/shipment/shipment_nbr/validate'
      post url, 
      
      shipment: {
        client: @client,
        warehouse: @warehouse,
        channel: @channel,
        building:@building,
        location: @location,
        case_id: @case_id,
        item: @item,
        quantity: @quantity,
        shipment_nbr: 'Shipment2x'
      }
        message =  JSON.parse(response.body)
        expected_message = 'Shipment Shipment2x not found'
        assert_equal expected_message , message.errors[0].message,  "Shipment not found"
       
  end
  
  def test_validate_shipment_record_status
    url  = '/shipment/shipment_nbr/validate'
    post url, 
       
    shipment: {   
        client: @client,
        warehouse: @warehouse,
        channel: @channel,
        building:@building,
        shipment_nbr: asn_headers(:three).shipment_nbr ,
        location: location_masters(:four).barcode,
        case_id: @case_id,
        item: @item,
        quantity: @quantity
     } 
       message =  JSON.parse(response.body)
       expected_message =  "Shipment #{asn_headers(:three).shipment_nbr} not initiated"
       assert_equal expected_message , message.errors[0].message,  "Validate shipment record status"
    
  end
  
  def test_validate_if_the_shipment_is_received_to_pre_define_dock_door
    url  = '/shipment/shipment_nbr/validate'
    GlobalConfiguration.set_configuration({value: 't'}, @condition.merge({key: 'Yard_Management'}))
    post url,
    
      shipment: { 
        client: @client,
        warehouse: @warehouse,
        channel: @channel,
        building:@building,
        shipment_nbr: asn_headers(:two).shipment_nbr ,
        location: nil,
        case_id: @case_id,
        item: @item,
        quantity: @quantity
      }
       message =  JSON.parse(response.body)
       expected_message = 'Shipment Shipment2 not assigned to this Dock Door'
       assert_equal expected_message , message.errors[0].message,  "Shipment not received at incorrect Location"       
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
         case_id:  nil,
         item: @item
      }  
         message = JSON.parse(response.body)
         expected_message = 'Enter Case' 
         assert_equal expected_message , message.errors[0].message, "Case not Entered" 
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
       assert_equal expected_message , message.errors[0].message, "Case not found" 
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
       assert_equal expected_message , message.errors[0].message, "Case already received"  
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
    expected_message = 'Case '+  case_headers(:one).case_id + ' already exists' 
    assert_equal expected_message , message.errors[0].message, "Case  not found" 
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
         case_id:  case_headers(:one).case_id,
         item: @item
      }  
         message = JSON.parse(response.body)
         expected_message = {case_id: case_details(:one).case_id, item: case_details(:one).item, quantity: case_details(:one).quantity} 
         #expected_message = 'Enter Case' 
         assert_equal expected_message , message.additional_info[0].symbolize_keys, "Case not Entered" 
  end
  
  def test_validate_item_not_in_itemmaster
    
    url = '/shipment/item/validate'
    post url, 
    
    shipment: {   
        client: @client,
        warehouse: @warehouse,
        channel: @channel,
        building:@building,
        shipment_nbr:@shipment,
        location: @location,
        case_id: @case_id,
        item: 'abcd',
        quantity: @quantity
    }  
        message =  JSON.parse(response.body)
        expected_message = 'Item abcd does not exist in Itemmaster'
        assert_equal expected_message , message.errors[0].message,  "Item not found"
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
        assert_equal expected_message , message.errors[0].message, "Item not found"
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
        building:@building,
        location: @location,
        shipment_nbr: @shipment_nbr,
        case_id: case_headers(:case_one).case_id,
        item: '1234678',
        quantity: @quantity
    }  
        message =  JSON.parse(response.body)
        expected_message = 'Item 1234678 is not associated to this Case'
        assert_equal expected_message , message.errors[0].message,  "Item not found in Case"
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
        building:@building,
        location: @location,
        shipment_nbr: @shipment_nbr,
        case_id: case_headers(:case_three).case_id,
        item: case_details(:case_three).item,
        quantity: case_details(:case_three).quantity + 1
    }          
        message =  JSON.parse(response.body)
        expected_message = 'Quantity entered does not match with the qty on the case'
        assert_equal expected_message , message.errors[0].message,  "Quantity mismatch"
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
        building:@building,
        location: @location,
        shipment_nbr: @shipment_nbr,
        case_id: '@case1',
        item: asn_details(:one).item,
        quantity: asn_details(:one).shipped_quantity - asn_details(:one).received_qty + 1
     }         
        message =  JSON.parse(response.body)
        expected_message = 'Quantity received exceeds shipped quantity'
        assert_equal expected_message , message.errors[0].message,  "Quantity mismatch in SKU"
  end
 
end