module Inventory
  
  class CaseMaintenance
    include CaseMaintenanceHeader
    include CaseMaintenanceHeader
    include Response
    include Utility
    attr_accessor :message, :error
    
    def initialize
      @message = {}
      @error = []
    end
     def get_cases(basic_parameters, filter_conditions, expand=nil)
    
        if expand.nil?
          #case_header_data = [:id, :case_id, :quantity, :record_status]  
          #case_detail_data = [:id, :item, :quantity, :record_status] 
          case_header_data = '*'
          case_detail_data = '*'
        else
          case_header_data = '*'
          case_detail_data = '*'
        end
        
        basic_parameters[:building] =  basic_parameters[:building].blank? ? nil : basic_parameters[:building]
        basic_parameters[:channel] =  basic_parameters[:channel].blank? ? nil : basic_parameters[:channel] 
          
        case_headers = CaseHeader.select(case_header_data).where(basic_parameters).where(filter_conditions).order(:id)
        case_hash = []
        case_headers.each do |case_header|
          case_details = CaseDetail.select(case_detail_data).where(case_header_id: case_header.id)    
          case_hash << { case_header:  case_header , case_detail: case_details }
        end
        case_hash
        
      end
   end
end