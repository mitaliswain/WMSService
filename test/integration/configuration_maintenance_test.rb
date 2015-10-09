require 'test_helper'

class ConfigurationMaintenanceTest < ActionDispatch::IntegrationTest
  fixtures :global_configurations
  def setup
    @url = '/configuration/' + global_configurations(:one).id.to_s
    @client = 'WM'
    @warehouse = 'WH1'
    @building = nil
    @channel = nil

    message = post("/authenticate/signin",
                   user_details: {
                       client: @client,
                       user_id: 'U1',
                       password: 'password'
                   })

    @token = JSON.parse(response.body)["additional_info"][0]["token"]
  end  
  
  test 'update configuration value' do
    configuration = GlobalConfiguration.find(global_configurations(:one).id )
    message = put(@url, 
    app_parameters:{
      client:'WM', warehouse: 'WH1', building: '', channel: ''
    },  
    fields_to_update: {
        value: 'new'
        },
    authorization: @token)
    configuration_updated = GlobalConfiguration.find(global_configurations(:one).id )
    assert_equal 201, status, 'Updated shipment status'
    assert_equal 'new', configuration_updated.value, 'Updated configuration data'

  end


  test 'update configuration value just with key and value' do

    url = '/configuration/update_key/Receiving_Type'
    message = put(url,
                  app_parameters:{
                      client:'WM', warehouse: 'WH1', building: '', channel: ''
                  },
                  filter_condition:{
                      module:'RECEIVING',
                  },
                  fields_to_update: {
                      value: 'Case'
                  },
                  authorization: @token)
    configuration_updated = GlobalConfiguration.find(global_configurations(:one).id )
    assert_equal 200, status, 'Updated shipment status'
    assert_equal 'Case', configuration_updated.value, 'Updated configuration data'

    #reverse the setup
    url = '/configuration/update_key/Receiving_Type'
    message = put(url,
                  app_parameters:{
                      client:'WM', warehouse: 'WH1', building: '', channel: ''
                  },
                  filter_condition:{
                      module:'RECEIVING'
                  },
                  fields_to_update: {
                      value: 'SKU'
                  },
                  authorization: @token)
    configuration_updated = GlobalConfiguration.find(global_configurations(:one).id )
    assert_equal 200, status, 'Updated shipment status'
    assert_equal 'SKU', configuration_updated.value, 'Updated configuration data'


  end

end 