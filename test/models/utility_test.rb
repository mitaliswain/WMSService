require 'test_helper'
require 'utility'


class UtilityValue
  include Utility
end

class ResponseValueTest < ActiveSupport::TestCase

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
   
   test "test the  valid app parameters" do
    message = valid_app_parameters?({client: 'WM', warehouse: 'WH1', channel: '', building: ''})
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
   
end