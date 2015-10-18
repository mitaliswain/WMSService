require 'test_helper'

class ConfigurationMaintenanceIntegrationTest < ActionDispatch::IntegrationTest
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


 test 'add configuration value just with key and value' do

    url = '/configuration'
    message = post(url,
                  app_parameters:{
                      client:'WM', warehouse: 'WH1', building: '', channel: ''
                  },
                  fields_to_update: {
                  "client"=> "WM",
                  "warehouse"=> "WH1",
                  "channel"=> nil,
                  "building"=> nil,
                  "sequence_no"=> 1,
                  "module"=> "RECEIVING",
                  "module_description"=> "MyString",
                  "submodule1"=> "MyString",
                  "submodule2"=> "MyString",
                  "submodule3"=> "MyString",
                  "submodule4"=> "MyString",
                  "submodule5"=> "MyString",
                  "user"=> "MyString",
                  "user_role"=> "MyString",
                  "app_id"=> 1,
                  "key"=> "Enter_quantity_case_ASN",
                  "value"=> "Force",
                  "attribute1"=> "{\"Options\"=> [\"Force\",\"Never\"]}\n",
                  "attribute2"=> "MyString",
                  "attribute3"=> "MyString",
                  "attribute4"=> "MyString",
                  "attribute5"=> "MyString",
                  "attribute6"=> "MyString",
                  "attribute7"=> "MyString",
                  "attribute8"=> "MyString",
                  "attribute9"=> "MyString",
                  "attribute10"=> "MyString",
                  "enable"=> true
              },
                  authorization: @token)
    configuration_updated = GlobalConfiguration.find(global_configurations(:one).id )
    assert_equal 201, status, 'Added configuration status'

  end

 test 'bulk add of configuration' do

    url = '/configuration'
    message = post("#{url}/bulk_create",
                  app_parameters:{
                      client:'WM', warehouse: 'WH1', building: '', channel: ''
                  },
                  configuration_headers: [{
                  "client"=> "WM",
                  "warehouse"=> "WH1",
                  "channel"=> nil,
                  "building"=> nil,
                  "sequence_no"=> 1,
                  "module"=> "RECEIVING",
                  "module_description"=> "MyString",
                  "submodule1"=> "MyString",
                  "submodule2"=> "MyString",
                  "submodule3"=> "MyString",
                  "submodule4"=> "MyString",
                  "submodule5"=> "MyString",
                  "user"=> "MyString",
                  "user_role"=> "MyString",
                  "app_id"=> 1,
                  "key"=> "Enter_quantity_case_ASN",
                  "value"=> "Force",
                  "attribute1"=> "{\"Options\"=> [\"Force\",\"Never\"]}\n",
                  "attribute2"=> "MyString",
                  "attribute3"=> "MyString",
                  "attribute4"=> "MyString",
                  "attribute5"=> "MyString",
                  "attribute6"=> "MyString",
                  "attribute7"=> "MyString",
                  "attribute8"=> "MyString",
                  "attribute9"=> "MyString",
                  "attribute10"=> "MyString",
                  "enable"=> true
              },
              
                 { "client"=> "WM",
                  "warehouse"=> "WH1",
                  "channel"=> nil,
                  "building"=> nil,
                  "sequence_no"=> 1,
                  "module"=> "RECEIVING",
                  "module_description"=> "MyString",
                  "submodule1"=> "MyString",
                  "submodule2"=> "MyString",
                  "submodule3"=> "MyString",
                  "submodule4"=> "MyString",
                  "submodule5"=> "MyString",
                  "user"=> "MyString",
                  "user_role"=> "MyString",
                  "app_id"=> 1,
                  "key"=> "QC_Sampling",
                  "value"=> "t",
                  "attribute1"=> "---\nOptions=>\n- 'Yes'\n- 'No'\n- User_Defined\n",
                  "attribute2"=> "MyString",
                  "attribute3"=> "MyString",
                  "attribute4"=> "MyString",
                  "attribute5"=> "MyString",
                  "attribute6"=> "MyString",
                  "attribute7"=> "MyString",
                  "attribute8"=> "MyString",
                  "attribute9"=> "MyString",
                  "attribute10"=> "MyString",
                  "enable"=> true}],
                  authorization: @token)
    configuration_updated = GlobalConfiguration.find(global_configurations(:one).id )
    assert_equal 201, status, 'Added configuration status'

  end

end 