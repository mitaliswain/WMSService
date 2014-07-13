require 'test_helper'

class GlobalConfigurationTest < ActiveSupport::TestCase
 
 test "get the correct configuration" do
   condition = {client: 'WM', warehouse: 'WH1', building: nil , channel: nil, module:'RECEIVING'}
   configuration = GlobalConfiguration.get_configuration(condition)
   expected_value = 'SKU'    
  assert_equal expected_value, configuration.Receiving_Type, "Get correct configuration"
 end

 test "condition not found throw exception" do
   condition = {client: 'WMX', warehouse: 'WHX', building: nil , channel: nil, module:'RECEIVING'}
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
   setup = {value: 'Case'}
   exception = assert_raise(ArgumentError) do 
     GlobalConfiguration.set_configuration(setup, condition=condition.merge({key: 'Receiving_Type'}))
   end
   assert_equal "Invalid Argument #{condition} or config value #{setup}" , exception.message, "Validate the Arguments"
 end

 test "setup criteria not valid" do
   condition = {client: 'WM', warehouse: 'WH1', building: nil , channel: nil, module:'RECEIVING'}
   setup = {valuex: 'Case'}
   exception = assert_raise(ArgumentError) do 
     GlobalConfiguration.set_configuration(setup, condition=condition.merge({key: 'Receiving_Type'}))
   end
   assert_equal "Invalid Argument #{condition} or config value #{setup}" , exception.message, "Validate the update"
 end
 
  test "check the new API for valid configuration" do
   condition = {client: 'WM', warehouse: 'WH1', building: nil , channel: nil}
   configuration = GlobalConfiguration.options(condition).options(module:'RECEIVING').get
   expected_value = 'SKU'    
   assert_equal expected_value, configuration.Receiving_Type, "Get correct configuration for new API"
 end
 
 test "condition not found throw exception new API" do
   condition = {client: 'WM', warehouse: 'WHX', building: nil , channel: nil}
   configuration = GlobalConfiguration.options(condition).options(module:'RECEIVING')
   exception = assert_raise(ArgumentError) { configuration.get.Receiving_Type}
   assert_equal "Invalid Argument #{condition.merge(module:'RECEIVING')}" , exception.message, "Validate the message"
 end
 
  test "set the correct configuration new API" do
   condition = {client: 'WM', warehouse: 'WH1', building: nil , channel: nil}
   configuration = GlobalConfiguration.options(condition).options(module:'RECEIVING').get
   configuration.Receiving_Type = 'Case'
   configuraiton.post
   new_configuration = GlobalConfiguration.options(condition).options(module:'RECEIVING').get
   expected_value = 'Case'  
   assert_equal expected_value, new_configuration.Receiving_Type, "Get correct configuration for API"
 end

 
end
