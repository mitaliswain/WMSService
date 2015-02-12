require 'test_helper'

class ItemMasterMaintenanceTest < ActionDispatch::IntegrationTest

  def setup
    @url = '/item_master/'
    @client = 'WM'
    @warehouse = 'WH1'
    @building = nil
    @channel = nil
  end

  test 'select item from ItemMaster' do
    item_count = ItemMaster.count
    get(@url)

    assert_equal item_count, JSON.parse(response.body).count, 'Total items in ItemMaster'

  end
=begin
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
=end

end