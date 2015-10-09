require 'test_helper'
require '././lib/utilities/json_web_token'

class JsonWebTokenTest < ActiveSupport::TestCase

  test "encode" do

    payload = {
        user_id: 'Jagannath',
        user_name: 'Jagannath Prasad Lenka',
        password: 'Password'
    }

    token = JsonWebToken.encode(payload)
    decoded = JsonWebToken.decode(token)


    assert_equal(payload[:user_name], decoded["user_name"], "Decoded")

  end

  test "decode" do

    payload = {
        user_id: 'Jagannath',
        user_name: 'Jagannath Prasad Lenka',
        password: 'Password'
    }

    token = JsonWebToken.encode(payload)
    sleep 3
    decoded = JsonWebToken.decode(token)


    p decoded

  end

end