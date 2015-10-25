require 'test_helper'

class CaseDetailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
   fixtures :case_details
  
  test "validate the uniqueness of case and item" do
    
    assert_raise ActiveRecord::RecordInvalid do
     CaseDetail.create!(client: case_details(:one).client, warehouse: case_details(:one).warehouse,
                        case_id: case_details(:one).case_id, item: case_details(:one).item)
    end

  end
  test "update channel and building to null for blank input" do
    
     CaseDetail.create!(client: case_details(:one).client, warehouse: case_details(:one).warehouse, case_header_id: case_headers(:one).id,
                        case_id: '_' + case_details(:one).case_id,item: case_details(:one).item, building: "", channel: "")
     case_detail = CaseDetail.where(client: case_details(:one).client, warehouse: case_details(:one).warehouse, 
                        case_id: '_' + case_details(:one).case_id, item: case_details(:one).item).first
                      
     assert_equal(nil, case_detail.channel, 'update blank channel to null' )   
     assert_equal(nil, case_detail.building, 'update blank building to null' )                
  end

  test "check the inventory location quantity changed" do

    case_header = CaseHeader.new
    case_header.client = 'WM'
    case_header.warehouse = 'WH1'
    case_header.location = 'Location1'
    case_header.case_id = 'CaseID001'
    case_header.save!

    case_detail = CaseDetail.new
    case_detail.client = case_header.client
    case_detail.case_id = case_header.case_id
    case_detail.warehouse = case_header.warehouse
    case_detail.case_header_id = case_header.id
    case_detail.quantity = 10
    case_detail.item = '12345'
    case_detail.save!

    location_inventory = LocationInventory.where(barcode: 'Location1', item: '12345').first
    assert_equal(location_inventory.quantity, case_detail.quantity , 'Location Inventory added')

    case_detail.quantity = case_detail.quantity - 2
    case_detail.save!

    location_inventory = LocationInventory.where(barcode: 'Location1', item: '12345').first
    assert_equal(8, location_inventory.quantity, 'Location Inventory updated')

  end

end
