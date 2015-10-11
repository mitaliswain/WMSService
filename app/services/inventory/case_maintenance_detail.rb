module Inventory
  require 'utilities/utility'
  require 'utilities/response'

  include Utility
  include Response

  module CaseMaintenanceDetail

    def update_case_detail(app_parameters, id, fields_to_update)
      input_obj = app_parameters.merge(fields_to_update).merge(id: id).to_hash
      if valid_app_parameters?(input_obj) &&
          valid_data?(input_obj)

        case_hash = CaseDetail.find(id)
        fields_to_update.each do |field, data|
          case_hash.attributes =  {field => data}
        end
        case_hash.save!
        resource_updated_successfully("Shipment Detail #{id}")
      end
      message
    end


    def add_case_detail(app_parameters, fields_to_add)
      input_obj = app_parameters.merge(fields_to_add).to_hash
      if valid_input?(input_obj)
        case_hash = CaseDetail.new(input_obj)
        case_hash = add_case_detail_derived_data(case_hash.clone)
        case_hash.save!
        resource_added_successfully("Case #{case_hash.id}", "/case/#{case_hash.case_header_id}/#{case_hash.id}")
      end
      message
    end

    def valid_input?(input_obj)
      (valid_app_parameters?(input_obj) &&
          valid_mandatory_fields?(input_obj) &&
          valid_data?(input_obj))  ? true : false
    end

    def add_case_detail_derived_data(case_detail_clone)
      case_detail = case_detail_clone
      case_header = CaseHeader.find(case_detail.case_header_id)
      case_detail.case_id = case_header.case_id
      case_detail.description = @item_master.description
      case_detail.short_desc = @item_master.short_desc
      case_detail.barcode = @item_master.barcode
      #case_detail.inventory_type = @item_master.inventory_type
      case_detail.unit_weight = @item_master.unit_wgt
      case_detail.unit_volume = @item_master.unit_vol
      case_detail
    end


    def get_next_sequence(case_hash)
      case_detail = CaseDetail.where(client: case_hash.client, case_id: case_hash.case_id).order(:sequence).last
      case_detail.nil? ? 1: case_detail.sequence.to_i + 1
    end

    def valid_data?(fields_to_update)
      is_valid = true
      fields_to_update.each do |field, value|
        method ="valid_#{field.to_s}?"
        is_valid = (respond_to?(method) ? send(method, fields_to_update) : true)  && is_valid
      end
      is_valid

    end

    def valid_mandatory_fields?(fields_to_update)
      is_valid = true
      is_valid = valid_case_header_id?(fields_to_update) && is_valid
      is_valid = valid_item?(fields_to_update) && is_valid
      is_valid
    end


    def valid_case_header_id?(fields_to_update)
      if !fields_to_update.symbolize_keys.has_key?(:case_header_id)
        validation_failed('422', :case_header_id, 'Case Header ID is blank')
      else
        true
      end
    end

    def valid_item?(fields_to_update)
      case
        when !fields_to_update.symbolize_keys.has_key?(:item)
          validation_failed('422', :item, 'Please enter the item')

        when !fields_to_update.item.present?
          validation_failed('422', :item, 'Item can not be nil or blank!')
        else
          @item_master = ItemMaster.where(client: fields_to_update.client, item: fields_to_update.item).first
          @item_master.nil? ? validation_failed('422', :item, 'Item not in item master') : true
      end
    end

  end

end