require 'test_helper'

class CaseHeaderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
   fixtures :case_headers
  
  test "validate the uniqueness of case" do
    
    assert_raise ActiveRecord::RecordInvalid do
     CaseHeader.create!(client: case_headers(:one).client, warehouse: case_headers(:one).warehouse, case_id: case_headers(:one).case_id)
    end

  end
  
   test "update channel and building to null for blank input" do
    
     CaseHeader.create!(client: case_headers(:one).client, warehouse: case_headers(:one).warehouse, 
                        case_id: '_' + case_headers(:one).case_id, building: "", channel: "")
     case_header = CaseHeader.where(client: case_headers(:one).client, warehouse: case_headers(:one).warehouse, 
                        case_id: '_' + case_headers(:one).case_id).first
                      
     assert_equal(nil, case_header.channel, 'update blank channel to null' )   
     assert_equal(nil, case_header.building, 'update blank building to null' )                
  end
end
