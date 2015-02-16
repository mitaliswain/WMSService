require 'test_helper'

class ItemMasterMaintenanceTest < ActionDispatch::IntegrationTest
  fixtures :item_masters
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

  test 'update configuration value' do

    item = ItemMaster.find(item_masters(:one).id )

    message = put("#{@url}#{item_masters(:one).id}",
                  app_parameters:{
                      client:'WM', warehouse: 'WH1', building: '', channel: ''
                  },
                  fields_to_update: {
                      description: "new_#{item.description}"
                  })
    item_updated = ItemMaster.find(item_masters(:one).id )
    assert_equal 201, status, 'Updated item  status'
    assert_equal "new_#{item.description}", item_updated.description, 'Updated Item description'

  end


end