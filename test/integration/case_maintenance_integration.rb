require 'test_helper'
require 'json'

class CaseReceiveIntegrationTest < ActionDispatch::IntegrationTest
 

fixtures :case_headers
fixtures :case_details
fixtures :item_masters
fixtures :global_configurations


  def test_the_case_details_with_no_parameter
    
    url = '/case/'
    get(url, 
    app_parameters:{
      client:'WM', warehouse: 'WH1', building: '', channel: ''
    })
    assert_equal case_headers(:one).case_id, JSON.parse(response.body)[0]['case_header']['case_id'], 'get the case header detail'
   
    
  end

  def test_the_update_of_single_field
    case_header = CaseHeader.where(case_id: case_headers(:two).case_id).first
    url = "/case/#{case_header.id}/update_header"
    post(url,
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

  def test_the_add_case_header

    url = '/case/add_header'
    post(url,
         app_parameters:{
             client:'WM', warehouse: 'WH1', building: '', channel: ''
         },
         fields_to_update: {
             case_id: '2014110301'
         } )
    case_header = CaseHeader.find_by_case_id('2014110301')
    assert_not_nil case_header, 'added case header'
  end

  def test_the_add_case_detail
    case_header = CaseHeader.where(case_id: case_headers(:two).case_id).first
    case_detail = CaseDetail.where(client: case_header.client, case_id: case_header.case_id)
    initial_records = case_detail.size
    url = '/case/add_detail'
    post(url,
         app_parameters:{
             client:'WM', warehouse: 'WH1', building: '', channel: ''
         },
         fields_to_update: {
             case_id: case_header.case_id,
             case_header_id: case_header.id,
             item: item_masters(:one).item,
             quantity: '10',
             record_status: 'Created'
         } )
    case_detail_new = CaseDetail.where(client: case_header.client, case_id: case_header.case_id)
    assert_equal initial_records + 1, case_detail_new.size, 'details added successfully'
  end

end