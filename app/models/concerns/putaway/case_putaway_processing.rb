module Putaway


    module CasePutawayProcessing
      extend ActiveSupport::Concern

      def case_putaway
        resource_processed_successfully(self.putaway.case_id, "putaway done successfully for the case")
      end
    end
  end