require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  fixtures :messages
    
  test "no parameters" do
    message = Message.get_message(messages(:no_param).client,messages(:no_param).message_id )
    expected = 'This message has no parameters'
    assert_equal expected, message, "No parameters"
  end
 
  test "one parameters" do
    message = Message.get_message(messages(:one_param).client,messages(:one_param).message_id , ['one'])
    expected = 'This message has one parameter'
    assert_equal expected, message, "One parameters"
  end
  
  test "multiple parameters" do
    message = Message.get_message(messages(:multiple_param).client,messages(:multiple_param).message_id, ['three', 'first', 'second'] )
    expected = 'This message has three parameters & first param is first, second one is second'
    assert_equal expected, message, "No parameters"
  end
  
  test "message not found" do
    message =  Message.get_message('WX', '--blank' )
    expected = 'No message found for --blank'
    assert_equal expected, message, "message not found"
  end
 
  
end
