require 'test_helper'
require 'utilities/utility'


class UtilityValue
  attr_accessor :building, :channel
  include Utility
end

class ResponseValueTest < ActiveSupport::TestCase

fixtures :global_configurations

  test "test the if the bulding and channels are getting conveted to null" do
    ut = UtilityValue.new
    ut.building = ' '
    ut.channel = ' '
    ut.convert_blank_to_null_for_building_and_channel    
    assert_equal(nil, ut.building, 'Convert blank building to null')   
    assert_equal(nil, ut.channel, 'Convert blank channel to null')   

  end

  test "test the valid client" do
   
    message = valid_client?({client: 'WM'})
    assert_equal(true, message, 'Valid Client' )
   end

   test "test the  client does not exist" do
    message = valid_client?({warehouse: 'WH1'})
    assert_equal(false, message, 'no client exist' )
   end

   test "test the  invalid client" do
    message = valid_client?({client: 'WM1'})
    assert_equal(false, message, 'Invalid client' )
   end
   
   test "test the  valid app parameters bu" do
    message = valid_warehouse?({client: 'WM', warehouse: 'WH1', channel: nil, building: nil})
    assert_equal(true, message, 'Valid Parameters' )
   end 

   test "test the  valid app parameters cha" do
    message = valid_building?({client: 'WM', warehouse: 'WH1', channel: nil, building: nil})
    assert_equal(true, message, 'Valid Parameters' )
   end 

   test "test the  valid app parameters" do
    message = valid_channel?({client: 'WM', warehouse: 'WH1', channel: nil, building: nil})
    assert_equal(true, message, 'Valid Parameters' )
   end 

   test "test the  valid app parameters with other parameters" do
    app_parameters = {client: 'WM', warehouse: 'WH1', channel: '', building: ''} 
    id = 1
    fields_to_validate = {item: '12345'}
    input_object = app_parameters.merge(id: id).merge(fields_to_validate)
    
    message = valid_app_parameters?(input_object)
    assert_equal(true, message, 'Valid Parameters' )
   end 
   
   test "one up number" do
     num = get_next_one_up_number({client: 'WM', warehouse: 'WH1', building: nil, channel: nil }, 'SHIPMENT')
     assert_equal(2, num, "one up number increased")
     
     num = get_next_one_up_number({client: 'WM', warehouse: 'WH1', building: nil, channel: nil }, 'SHIPMENT')
     assert_equal(3, num, "one up number increased")

   end
   
   
end