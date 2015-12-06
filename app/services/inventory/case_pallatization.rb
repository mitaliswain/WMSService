module Inventory

  class   CasePallatization
    include Response
    include Utility

    attr_accessor :pallate_id, :cases_to_be_palletized, :message, :app_parameters
      def initialize( app_parameters, pallate_id, cases_to_be_palletized)
        @pallate_id = pallate_id
        @app_parameters = app_parameters
        @cases_to_be_palletized = cases_to_be_palletized
        @message = {}
      end

       def  palletize
         cases_to_be_palletized.each do |case_to_be_palletize|
           case_id = CaseHeader.where(client: app_parameters.client, warehouse: app_parameters.warehouse, case_id: case_to_be_palletize).first
           if case_id
             case_id.pallet_id = @pallate_id
             case_id.save
           end
           resource_processed_successfully(@pallate_id, "Cases added to the pallate")
         end
       end
  end


end

