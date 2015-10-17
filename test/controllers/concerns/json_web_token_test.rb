require 'test_helper'

class JsonWebTokenTest < ActiveSupport::TestCase
include JsonWebToken

  test "encode" do

    payload = {
        user_id: 'Jagannath',
        user_name: 'Jagannath Prasad Lenka',
        password: 'Password'
    }

    token = JsonWebToken.new.encode(payload)
    decoded = JsonWebToken.new.decode(token)


    assert_equal(payload[:user_name], decoded["user_name"], "Decoded")

  end

  test "decode" do

    payload = {
        user_id: 'Jagannath',
        user_name: 'Jagannath Prasad Lenka',
        password: 'Password'
    }

    token = JsonWebToken.new.encode(payload)
    sleep 3
    decoded = JsonWebToken.new.decode(token)


    p decoded

  end

end