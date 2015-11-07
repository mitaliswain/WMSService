module Putaway


    module CasePutawayProcessing

      def case_putaway
        update_case_header
        resource_processed_successfully(self.putaway.case_id, "putaway done successfully for the case")
      end

      def update_case_header
        case_header = CaseHeader.where(client: putaway[:client], case_id: putaway[:case_id]).first
        case_header.location=  putaway[:location]
        case_header.record_status = 'Ready'
        case_header.save!
        case_header
      end

    end
  end