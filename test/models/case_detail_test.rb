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
end
