require 'test_helper'

class GlobalConfigurationTest < ActiveSupport::TestCase
 
 test "get the correct configuration" do
   condition = {client: 'WM', warehouse: 'WH1', building: nil , channel: nil, module:'RECEIVING'}
   configuration = GlobalConfiguration.get_configuration(condition)
   expected_value = 'SKU'    
  assert_equal expected_value, configuration.Receiving_Type, "Get correct configuration"
 end

 test "condition not found throw exception" do
   condition = {client: 'WMX', warehouse: 'WHX', building: nil , channels: nil, module:'RECEIVING'}
   exception = assert_raise(ArgumentError) { GlobalConfiguration.get_configuration(condition)}
   assert_equal "Invalid Argument #{condition}" , exception.message, "Validate the message"
 end


 test "set the correct configuration" do
   condition = {client: 'WM', warehouse: 'WH1', building: nil , channel: nil, module:'RECEIVING'}
   configuration = GlobalConfiguration.set_configuration({value: 'Case'}, condition.merge({key: 'Receiving_Type'}))
   expected_value = 'Case'    
   assert_equal expected_value, configuration.Receiving_Type, "Get correct configuration"
 end
 
 test "condition not found throw exception for setting configuration" do
   condition = {client: 'WMX', warehouse: 'WHX', building: nil , channels: nil, module:'RECEIVING'}
   exception = assert_raise(ArgumentError) do 
     GlobalConfiguration.set_configuration({value: 'Case'}, condition=condition.merge({key: 'Receiving_Type'}))
   end
   assert_equal "Invalid Argument #{condition}" , exception.message, "Validate the Arguments"
 end

 test "setup criteria not valid" do
   condition = {client: 'WM', warehouse: 'WH1', building: nil , channel: nil, module:'RECEIVING'}
   setup = {valuex: 'Case'}
   exception = assert_raise(ArgumentError) do 
     GlobalConfiguration.set_configuration(setup, condition=condition.merge({key: 'Receiving_Type'}))
   end
   assert_equal "Invalid setup #{setup}" , exception.message, "Validate the update"
 end

 
end
