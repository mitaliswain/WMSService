require 'test_helper'
require 'response'


class ResponseValue
  include Response
end

class ResponseValueTest < ActiveSupport::TestCase

  test "test the invalid valid message for creation" do
    message = ResponseValue.new.resource_added_successfully('Shipment', '/shipment/21')
    expected_message = 
       { status: '201' ,
        message: 'Shipment Created Successfully' ,
        content: [
          {code: '200',
           link: '/shipment/21'}
          ]
        }
    assert_equal(expected_message, message, 'Shipment Created successfully' )
   end

  test "test the invalid valid message for deletion" do
    message = ResponseValue.new.resource_deleted_successfully('Shipment')
    expected_message = 
       { status: '204' ,
        message: 'Shipment Deleted Successfully' ,
        }
    assert_equal(expected_message, message, 'Shipment Deleted successfully' )
   end

  test "test reource not found" do
    message = ResponseValue.new.resource_not_found('Shipment')
    expected_message = 
       { status: '404' ,
        message: 'Shipment not found' ,
        }
    assert_equal(expected_message, message, 'Shipment not found' )
   end

  test "validation failure" do
    message = ResponseValue.new.validation_failed('100','shipment_nbr','Shipment already exists')
    expected_message =
     
       { status: '422' ,
         message: 'Validation Failed' ,
         errors: [
         {
          code: '100',
          field: 'shipment_nbr',
          message: 'Shipment already exists'
         }
        ]
       }
    assert_equal(expected_message, message, 'Validation Failed' )
   end


test "multiiple validation failure" do
    responsevalue = ResponseValue.new  
    message = responsevalue.validation_failed('100','shipment_nbr','Shipment already exists')
    message = responsevalue.validation_failed('404' ,'ship_via','Ship via not found')
    expected_message =  
       { status: '422' ,
         message: 'Validation Failed' ,
         errors: [
         {
          code: '100',
          field: 'shipment_nbr',
          message: 'Shipment already exists'
         },
          {
          code: '404',
          field: 'ship_via',
          message: 'Ship via not found'
         }
        ]      
       }
    assert_equal(expected_message, message, 'Validation Failed' )
   end

end