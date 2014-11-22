
class ShipmentReceiveValidationTest < ActiveSupport::TestCase


  # test "the truth" do
  #   assert true
  # end
fixtures :asn_details
fixtures :asn_headers
fixtures :case_headers
fixtures :case_details
fixtures :location_masters
fixtures :item_masters
fixtures :global_configurations
fixtures :item_inner_packs
  
  def setup
    @condition = { client: 'WM', warehouse: 'WH1', building: nil, channel: nil, module: 'RECEIVING' }
    @configuration = GlobalConfiguration.get_configuration(@condition)
  end
  
  def shipment(hash=nil)
      shipment_hash = { client: 'WM',
        warehouse: 'WH1',
        channel: '',
        building: '',
        shipment_nbr: asn_headers(:one).shipment_nbr,
        location: '',
        case_id: '',
        item: '',
        quantity: 0
        }
       if hash
         hash.each do |k, v|
          shipment_hash[k] = v
         end
       end
       shipment_hash 
  end
  

  test "with blank location and yard management true" do
    GlobalConfiguration.set_configuration({value: 't'}, @condition.merge({key: 'Yard_Management'}))
    response = Shipment::ShipmentReceive.new(shipment).valid_location?
    assert_equal(false, response, 'Blank Location with yard management true')
    GlobalConfiguration.set_configuration({value: 'f'}, @condition.merge({key: 'Yard_Management'}))    
  end
  
  test "with pending location and yard management true" do
    GlobalConfiguration.set_configuration({value: 't'}, @condition.merge({key: 'Yard_Management'}))
    location = LocationMaster.where(client: shipment.client, warehouse: shipment.warehouse, barcode: location_masters(:one).barcode).first
    location.location_type = 'Pending'
    location.save!    
    
    shipment_h = shipment(location: location_masters(:one).barcode)
    rcv = Shipment::ShipmentReceive.new(shipment_h)
    response = rcv.valid_location?
    
    assert_equal(true, response, 'Pending location with yard management')
    GlobalConfiguration.set_configuration({value: 'f'}, @condition.merge({key: 'Yard_Management'}))    

    location.location_type =  location_masters(:one).location_type
    location.save!
  end

  test "with valid location and non pending location yard management true" do
    GlobalConfiguration.set_configuration({value: 't'}, @condition.merge({key: 'Yard_Management'}))
    location = LocationMaster.where(client: shipment.client, warehouse: shipment.warehouse, barcode: location_masters(:one).barcode).first
    location.location_type = 'Open'
    location.save!    
    
    shipment_h = shipment(location: location_masters(:one).barcode)
    
    rcv = Shipment::ShipmentReceive.new(shipment_h)
    
    response = rcv.valid_location?
        
    assert_equal(false, response, 'Pending location with yard management')    
    GlobalConfiguration.set_configuration({value: 'f'}, @condition.merge({key: 'Yard_Management'}))    

    location.location_type =  location_masters(:one).location_type
    location.save!
  end

  test "with valid shipment number" do

    shipment_h = shipment(shipment_nbr: asn_headers(:one).shipment_nbr)
    rcv = Shipment::ShipmentReceive.new(shipment_h)
    response = rcv.valid_location?
    
    assert_equal(true, response, 'Pending location with yard management')
  end

  test "with invalid shipment number" do
    
    AsnHeader.where(shipment_nbr: asn_headers(:one).shipment_nbr).first.destroy
    shipment_h = shipment(shipment_nbr: asn_headers(:one).shipment_nbr)
    rcv = Shipment::ShipmentReceive.new(shipment_h)
    response = rcv.valid_shipment?
    assert_equal(Message.get_message(shipment_h.client, 'RCV0004', [shipment_h.shipment_nbr]), rcv.message.errors[0].message, 'Pending location with yard management')    
    assert_equal(false, response, 'Invalid shipment')
  end

  test "with valid case id " do
    GlobalConfiguration.set_configuration({value: 'Case'}, @condition.merge({key: 'Receiving_Type'}))
    shipment_h = shipment(case_id: case_headers(:one).case_id)
    rcv = Shipment::ShipmentReceive.new(shipment_h)
    response = rcv.valid_case?
    assert_equal(true, response, 'Valid Case Id')
  end

  test "with invalid case Id" do
    
    GlobalConfiguration.set_configuration({value: 'Case'}, @condition.merge({key: 'Receiving_Type'}))    
    CaseHeader.where(case_id: case_headers(:one).case_id).each do |case_id|
      case_id.destroy
    end
    shipment_h = shipment(case_id: case_headers(:one).case_id)
    rcv = Shipment::ShipmentReceive.new(shipment_h)
    response = rcv.valid_case?
    assert_equal(Message.get_message(shipment_h.client, 'RCV0009', [shipment_h.case_id]), rcv.message.errors[0].message, 'Pending location with yard management')    
    assert_equal(false, response, 'Invalid Case id')
  end

  test "check valid data" do
    GlobalConfiguration.set_configuration({value: 'Case'}, @condition.merge({key: 'Receiving_Type'}))
    shipment_h = shipment(case_id: case_headers(:one).case_id)
    rcv = Shipment::ShipmentReceive.new(shipment_h)
    response = rcv.is_valid_receive_data?('case', shipment_h)
    assert_equal(true, response, 'Valid Case Id')
    
    
  end
 

end


