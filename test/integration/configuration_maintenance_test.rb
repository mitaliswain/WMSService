require 'test_helper'

class ConfigurationMaintenanceTest < ActionDispatch::IntegrationTest
  fixtures :global_configurations
  def setup
    @url = '/configuration/' + global_configurations(:one).id.to_s
    @client = 'WM'
    @warehouse = 'WH1'
    @building = nil
    @channel = nil
  end  
  
  test 'update configuration value' do
    
    configuration = GlobalConfiguration.find(global_configurations(:one).id )
    
    message = put(@url, 
    app_parameters:{
      client:'WM', warehouse: 'WH1', building: '', channel: ''
    },  
    fields_to_update: {
        value: 'new'
        }) 
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
                  })
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
                  })
    configuration_updated = GlobalConfiguration.find(global_configurations(:one).id )
    assert_equal 200, status, 'Updated shipment status'
    assert_equal 'SKU', configuration_updated.value, 'Updated configuration data'


  end

end 