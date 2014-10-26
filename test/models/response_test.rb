require 'test_helper'
require 'utilities/response'


class ResponseValue
  attr_reader :message
  include Response
end

class ResponseValueTest < ActiveSupport::TestCase

  test "test the invalid valid message for creation" do
    rs = ResponseValue.new
    ms = rs.resource_added_successfully('Shipment', '/shipment/21')
    expected_message = 
       { status: '201' ,
        message: 'Shipment Created Successfully' ,
        content: [
          {code: '200',
           link: '/shipment/21'}
          ]
        }
    assert_equal(expected_message, rs.message, 'Shipment Created successfully' )
   end

  test "test the invalid valid message for deletion" do
    rs = ResponseValue.new
    ms = rs.resource_deleted_successfully('Shipment')
    expected_message = 
       { status: '204' ,
        message: 'Shipment Deleted Successfully' ,
        }
    assert_equal(expected_message, rs.message, 'Shipment Deleted successfully' )
   end

  test "test reource not found" do
    rs = ResponseValue.new
    ms = rs.resource_not_found('Shipment')
    expected_message = 
       { status: '404' ,
        message: 'Shipment not found' ,
        }
    assert_equal(expected_message, rs.message, 'Shipment not found' )
   end

  test "validation failure" do
    rs = ResponseValue.new
    ms = rs.validation_failed('100','shipment_nbr','Shipment already exists')
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
    assert_equal(expected_message, rs.message, 'Validation Failed' )
   end

test "validation success with additional info" do
  rs = ResponseValue.new
  case_detail = {purchase_order_nbr: 'PO1', item: '1234', quantity: 10, inner_pack: 5 }
  ms = rs.validation_success(:case, case_detail)
  expected_message = 
     @message = {status:  '200',
    message: 'Validation Successful',
    errors: [{
              code: '200',
              field: :case,
              message: 'Validation Successful'
    }],
    additional_info: {purchase_order_nbr: 'PO1', item: '1234', quantity: 10, inner_pack: 5 }
    } 
end


test "multiiple validation failure" do
    responsevalue = ResponseValue.new  
    ms = responsevalue.validation_failed('100','shipment_nbr','Shipment already exists')
    ms = responsevalue.validation_failed('404' ,'ship_via','Ship via not found')
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
    assert_equal(expected_message, responsevalue.message, 'Validation Failed' )
   end
  
  test "invalid request" do
    responsevalue = ResponseValue.new  
    ms = responsevalue.invalid_request('xxx', 'Invalid validation requested')
    expected_message =  
       { status: '415' ,
         message: 'Invalid request',
         errors: [{
           code: '415',
           field: 'xxx',
           message: 'Invalid validation requested'
          }
         ]
       }  
    assert_equal(expected_message, responsevalue.message, 'Invalid request' )   
  end
  

end