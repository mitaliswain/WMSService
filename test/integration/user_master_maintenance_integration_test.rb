require 'test_helper'

class UserMasterMaintenanceIntegrationTest < ActionDispatch::IntegrationTest
  fixtures :user_masters
  def setup
    @url = '/user_master/'
    @client = 'WM'
    @building = nil
    @channel = nil
  end

  test 'select user from UserMaster' do
    user_count = UserMaster.count
    get(@url)

    assert_equal user_count, JSON.parse(response.body).count, 'Total users in ItemMaster'

  end


  test 'update user master value' do

    user = UserMaster.find(user_masters(:one).id )

    message = put("#{@url}#{user_masters(:one).id}",
                  app_parameters:{
                      client:'WM'
                  },
                  fields_to_update: {
                      user_name: "new_#{user.user_name}"
                  })
    user_updated = UserMaster.find(user_masters(:one).id )
    assert_equal 201, status, 'Updated user  status'
    assert_equal "new_#{user.user_name}", user_updated.user_name, 'Updated user name'

  end

  def test_the_add_user_master


    post(@url,
         app_parameters:{
             client:'WM'
         },
         fields_to_update: {
             user_id: 'Jagannath',
             user_name: 'Jagannath Prasad Lenka',
             password: 'Password'
         } )

    user = UserMaster.find_by_user_id('Jagannath')
    message = JSON.parse(response.body)
    assert_not_nil user, 'added item'
    assert_equal 201, status, 'Item added message'

    #Checking duplicate item

    post(@url,
         app_parameters:{
             client:'WM'
         },
         fields_to_update: {
             user_id: 'Jagannath',
             user_name: 'Jagannath Prasad Lenka',
             password: 'Password'
         } )

    assert_equal 500, status, 'Duplicate item message'
  end

end