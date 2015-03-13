require 'test_helper'
require 'json'

class CasePallatizationTest < ActionDispatch::IntegrationTest


fixtures :case_headers
fixtures :case_details
fixtures :item_masters
fixtures :global_configurations


  def test_palletize_case

    url = '/case/10/palletize'
    post(url,
         app_parameters:{
             client:'WM', warehouse: 'WH1', building: '', channel: ''
         },
         cases_to_be_palletized: [case_headers(:one).case_id, case_headers(:two).case_id]
    )

    case_header = CaseHeader.where(client: case_headers(:one).client, warehouse: case_headers(:one).warehouse, case_id: case_headers(:one).case_id).first

    assert_equal '10', case_header.pallet_id, 'Case got pallatize'

  end

end