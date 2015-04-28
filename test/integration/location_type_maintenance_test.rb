require 'test_helper'

class LocationTypeMaintenanceTest < ActionDispatch::IntegrationTest
  fixtures :location_types
  def setup
    @url = '/location_type/'
    @client = 'WM'
    @warehouse = 'WH1'
    @building = nil
    @channel = nil
  end

  test 'select location from LocationType' do
    location_count = LocationType.count
    get(@url)

    assert_equal location_count, JSON.parse(response.body).count, 'Total locations in LocationType'

  end

  test 'update location type value' do

    location = LocationType.find(location_types(:one).id )

    message = put("#{@url}#{location_types(:one).id}",
                  app_parameters:{
                      client:'WM', warehouse: 'WH1', building: '', channel: ''
                  },
                  fields_to_update: {
                      description: "new_#{location.description}"
                  })
    location_updated = LocationType.find(location_types(:one).id )
    p JSON.parse(response.body).message
    assert_equal 201, status, 'Updated location type  status'
    assert_equal "new_#{location.description}", location_updated.description, 'Updated location description'

  end
=begin
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

    #Checking duplicate location

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

    assert_equal 500, status, 'Duplicate location message'

  end

=end
end