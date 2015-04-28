require 'test_helper'

class LocationMasterMaintenanceTest < ActionDispatch::IntegrationTest
  fixtures :location_masters
  def setup
    @url = '/location_master/'
    @client = 'WM'
    @warehouse = 'WH1'
    @building = nil
    @channel = nil
  end

  test 'select location from LocationMaster' do
    location_count = LocationMaster.count
    get(@url)

    assert_equal location_count, JSON.parse(response.body).count, 'Total locations in LocationMaster'

  end

  test 'update location master value' do

    location = LocationMaster.find(location_masters(:one).id )

    message = put("#{@url}#{location_masters(:one).id}",
                  app_parameters:{
                      client:'WM', warehouse: 'WH1', building: '', channel: ''
                  },
                  fields_to_update: {
                      climate_contro: 'Freezer'
                  })
    location_updated = LocationMaster.find(location_masters(:one).id )
    assert_equal 201, status, 'Updated location master  status'
    assert_equal 'Freezer', location_updated.climate_control, 'Updated location climate control'

  end

  def test_the_add_location_master


    post(@url,
         app_parameters:{
             client:'WM', warehouse: 'WH1', building: '', channel: ''
         },
         fields_to_update: {
             location_type: 'Receiving',
              area: 'A1',
              zone: 'Z1',
              aisle: 'Al1',
              bay: 'B1',
              level: 'L1',
              position: 'P1',
              barcode: 'A1Z1Al1B1L1P1',
              climate_control: 'Freezer',
              minimum_temp: 20,
              maximum_temp: 40,
              lot_control_only: 'yes',
              serial_nbr_only: 1234
         } )

   location = LocationMaster.find_by_barcode('A1Z1Al1B1L1P1')
    assert_not_nil location, 'added location'
    assert_equal 201, status, 'Location added message'

    #Checking duplicate item

   post(@url,
         app_parameters:{
             client:'WM', warehouse: 'WH1', building: '', channel: ''
         },
         fields_to_update: {
             item: 'Item 1',
             short_desc: 'This is item 1',
             concept: 'PB'
         } )

    assert_equal 500, status, 'Duplicate item message'

  end


end