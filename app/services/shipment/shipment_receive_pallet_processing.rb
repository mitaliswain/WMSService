module Shipment
  module ShipmentReceivePalletProcessing
  
    def receive_pallet
      case_headers = CaseHeader.where(default_key)
                               .where(pallet_id: shipment.pallet)
      ActiveRecord::Base.transaction do

        begin
          receive_cases_in_the_pallet(case_headers)
        rescue
          fatal_error("Cases in pallet #{shipment.pallet} are already received", '')
        end

      end
        resource_processed_successfully(self.shipment.pallet, "Received Successfully")
    end

    def receive_cases_in_the_pallet(case_headers)
      case_headers.each do |case_to_be_received|
        case_detail = CaseDetail.where(default_key).where(case_id: case_to_be_received.case_id).first
        @shipment[:quantity] = case_detail.quantity
        @shipment[:item] = case_detail.item
        @shipment[:case_id] = case_to_be_received.case_id

        response = receive_shipment
        p response
        if  !response
          p 'raised'
          raise ActiveRecord::Rollback
        end

      end
    end

  end

     module ClassMethods
     end

end