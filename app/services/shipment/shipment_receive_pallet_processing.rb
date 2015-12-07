module Shipment
  module ShipmentReceivePalletProcessing
  
    def receive_pallet
      case_headers = CaseHeader.where(default_key)
                               .where(pallet_id: shipment.pallet)
      ActiveRecord::Base.transaction do

        begin
          receive_cases_in_the_pallet(case_headers)
          resource_processed_successfully(self.shipment.pallet, "Received Successfully")
          return true
        rescue => error
          fatal_error(error.to_s, error.backtrace[0])
          raise ActiveRecord::Rollback
          return false
        end
      end

    end

    def receive_cases_in_the_pallet(case_headers)
      case_headers.each do |case_to_be_received|
        case_detail = CaseDetail.where(default_key).where(case_id: case_to_be_received.case_id).first
        @shipment[:quantity] = case_detail.quantity
        @shipment[:item] = case_detail.item
        @shipment[:case_id] = case_to_be_received.case_id

        response = receive_shipment
        if  !response
          raise ActiveRecord::Rollback
        end

      end
    end

  end

     module ClassMethods
     end

end