module Putaway

  module CasePutawayValidation
    extend ActiveSupport::Concern

    def is_valid_putaway?(to_validate)
      method ="valid_#{to_validate.to_s}?"
      respond_to?(method) ? send(method) : validation_success(:case_id)

    end

    def valid_case_id?
      case_header = CaseHeader.where(client: putaway[:client], case_id: putaway[:case_id]).first
      case
        when case_header.nil?
             validation_failed('422', :case_id, 'Invalid Case id')
        when case_header.record_status != 'Received'
             validation_failed('422', :case_id, 'Invalid case status')

        else
             validation_success(:case_id)
      end
    end

    def valid_location?
      location = LocationMaster.where(client: putaway[:client], warehouse: putaway[:warehouse], channel: nil, building: nil, barcode:  putaway[:location] ).first
      case
        when location.location_type != 'RESERVE'
          validation_failed('422', :location, 'Location should be Reserved type')

        when !is_matching_putaway_type?(location)
          validation_failed('422', :location, 'Putaway type mismatch')

        else
        validation_success(:location)
      end

    end

  def is_matching_putaway_type?(location)
      CaseDetail.where(client: putaway[:client], case_id: putaway[:case_id] ).each do |case_item|
        item = ItemMaster.where(client: putaway[:client], channel: nil, building: nil, item: case_item.item).first
        if item.case_putaway_type != location.defalt_putaway_type
          return false
        end
      end
    true
  end


  end
end