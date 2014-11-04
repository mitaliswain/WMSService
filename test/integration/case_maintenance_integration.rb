require 'test_helper'
require 'json'

class CaseReceiveIntegrationTest < ActionDispatch::IntegrationTest
 

fixtures :case_headers
fixtures :case_details
fixtures :global_configurations


  def test_the_casedetails_with_no_parameter
    
    url = "/case/"
    get(url, 
    app_parameters:{
      client:'WM', warehouse: 'WH1', building: '', channel: ''
    }) 
    
    p JSON.parse(response.body)
    assert_equal case_headers(:one).case_id, JSON.parse(response.body)[0]['case_header']['case_id'], 'get the case header detail'
   
    
  end

  def test_the_update_of_single_field
    case_header = CaseHeader.where(case_id: case_headers(:two).case_id).first
    url = "/case/#{case_header.id}/update_header"
    message = post(url, 
    app_parameters:{
      client:'WM', warehouse: 'WH1', building: '', channel: ''
    },  
    fields_to_update: {
        perishble: 'No'
        }) 
    case_updated = CaseHeader.where(case_id: case_headers(:two).case_id).first
    #ssert_equal 201, status, 'Updated shipment status'
    assert_equal 'No', case_updated.perishble, 'Updated case data'
    
  end


end