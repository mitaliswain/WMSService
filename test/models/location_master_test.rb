require 'test_helper'

class LocationMasterTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
 test "add a new location and test if the default barcode is getting generated" do
    location = LocationMaster.new
    location.area = 'A1'
    location.zone = 'Z1'
    location.aisle = 'S1'
    location.bay = 'B1'
    location.level = 'L1'
    location.position = 'P1'
    location = location.save!
    
    createdlocation =  LocationMaster.find_by_barcode('A1Z1S1B1L1P1')
    assert_not_equal createdlocation, nil , 'Newly created barcode'
      
 end
 
end

