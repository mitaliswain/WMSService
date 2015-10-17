require 'test_helper'

class AuthenticateMaintenanceIntegrationTest < ActionDispatch::IntegrationTest
  fixtures :user_masters
  include JsonWebToken

  def setup
    @url = '/authenticate/'
    @client = 'WM'
  end


  test 'valid log in' do

    message = post("#{@url}signin",
                  user_details: {
                      client: @client,
                      user_id: 'U1',
                      password: 'password'
                  })

    payload = JsonWebToken.new.decode(JSON.parse(response.body)["additional_info"][0]["token"])
    assert_equal(payload["user_id"] , 'U1', "Same user id")

  end

  test 'Invalid log in' do

    message = post("#{@url}signin",
                   user_details: {
                       client: @client,
                       user_id: 'U1',
                       password: 'assword'
                   })
    assert_equal(message , 404 , "Invalid log in")

  end


end