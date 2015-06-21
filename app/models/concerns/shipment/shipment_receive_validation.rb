module Shipment

  module ShipmentReceiveValidation
    extend ActiveSupport::Concern


    SKU_RECEIVING = 'SKU'
    CASE_RECEIVING = 'Case'

    def is_valid_receive_data?(to_validate)

      valid_table = {
          'location' => 'valid_location?',
          'case' => 'valid_case?',
          'lot_number' => 'valid_lot_number?',
          'coo' => 'valid_coo?',
          'item' => 'valid_item?',
          'shipment_nbr' => 'valid_shipment?',
          'purchase_order_nbr' => 'valid_purchase_order_nbr?',
          'quantity' => 'valid_received_quantity?',
          'serial_nbr' => 'valid_serial_nbr?',
          'inner_pack' => 'valid_inner_pack?'
      }


      if valid_table.key?(to_validate)
        send(valid_table[to_validate])
      else
        invalid_request(:message, "#{to_validate}: Invalid validation requested")
      end
    end


    def valid_location?

      @location_master = LocationMaster.where(default_key)
                             .where(barcode: self.shipment.location).first

      #return validation_success(:location)    unless yard_management_enabled?
      # Validating Location
      case
        when @location_master.nil?
          validation_failed('422', :location, Message.get_message(self.shipment.client, 'RCV0001', [self.shipment.location]))

        when @location_master.location_type != 'Receiving'
          validation_failed('422', :location, Message.get_message(self.shipment.client, 'RCV0002', [self.shipment.location]))

        #when @location_master.record_status != 'Empty' && !shipment[:shipment_nbr].blank? 
        #validation_failed('422', :location, Message.get_message(shipment[:client], 'RCV0003', [shipment[:location]]))
        else
          validation_success(:location)
      end

    end


    def valid_shipment?
      @shipment_header = AsnHeader.where(default_key)
                             .where(shipment_nbr: self.shipment.shipment_nbr).first
      # validating shipment information

      case
        when @shipment_header.nil?
          validation_failed('422', :shipment_nbr, Message.get_message(self.shipment.client, 'RCV0004', [self.shipment.shipment_nbr]))

        when yard_management_enabled? &&
            shipment[:location] != @shipment_header.door_door
          validation_failed('422', :shipment_nbr, Message.get_message(self.shipment.client, 'RCV0005', [self.shipment.shipment_nbr]))

        when @shipment_header.record_status!= 'Initiated' && @shipment_header.record_status!= 'Receiving in Progress'
          validation_failed('422', :shipment_nbr, Message.get_message(self.shipment.client, 'RCV0006', [self.shipment.shipment_nbr]))
        else
          validation_success(:shipment_nbr)
      end

    end

    def valid_case?


      @case_header = CaseHeader.where(client: self.shipment.client, case_id: self.shipment.case_id).first
      case_detail = CaseDetail.where(case_id: @case_header.case_id).first if @case_header
      #checking whether case exist or not

      case
        when !self.shipment.case_id || self.shipment.case_id.blank?
          validation_failed('422', :case_id, Message.get_message(self.shipment.client, 'RCV0007', [self.shipment.case_id]))

        when SKU_receiving_enabled? && @case_header
          validation_failed('422', :case_id, Message.get_message(self.shipment.client, 'RCV0008', [self.shipment.case_id]))

        when Case_receiving_enabled? && @case_header.nil?
          validation_failed('422', :case_id, Message.get_message(self.shipment.client, 'RCV0009', [self.shipment.case_id]))

        when Case_receiving_enabled? && @case_header.record_status != 'Created'
          validation_failed('422', :case_id, Message.get_message(self.shipment.client, 'RCV0010', [self.shipment.case_id]))

        when Case_receiving_enabled? && !valid_case_receiving_item?
          validation_failed('422', :item, 'Item in case not valid')

        else
          validation_success(:case_id, get_additional_info_for_case(case_detail))
      end

    end

    def valid_case_receiving_item?
      @case_detail = CaseDetail.where(default_key).where(case_id: self.shipment.case_id).first
      self.shipment[:item] = @case_detail.item
      valid_item?
    end

    def valid_item?

      @item_master = ItemMaster.where(client: self.shipment.client, item: self.shipment.item).first
      @case_detail = CaseDetail.where(default_key).where(case_id: self.shipment.case_id, item: self.shipment.item).first
      shipment_detail = AsnDetail.where(default_key)
                            .where(shipment_nbr: self.shipment.shipment_nbr, item: self.shipment.item).first

      #validating item

      case
        when @item_master.nil?
          validation_failed('422', :item, Message.get_message(self.shipment.client, 'RCV0011', [self.shipment.item]))

        when shipment_detail.nil?
          validation_failed('422', :item, Message.get_message(self.shipment.client, 'RCV0012', [self.shipment.item]))

        when Case_receiving_enabled? && @case_detail.nil?

          validation_failed('422', :item, Message.get_message(self.shipment.client, 'RCV0013', [self.shipment.item]))

        else
          validation_success(:item)
      end

    end

    def valid_received_quantity?

      if valid_item?
        @message = {}
        shipment_details = AsnDetail.where(default_key)
                               .where(shipment_nbr: self.shipment.shipment_nbr, item: self.shipment.item)

        case
          when Case_receiving_enabled? &&
              is_received_quantity_not_matches_with_case?(@case_detail)
            validation_failed('422', :quantity, Message.get_message(self.shipment.client, 'RCV0014'))

          when is_received_quantity_greater_than_shipped?(shipment_details)
            validation_failed('422', :quantity, Message.get_message(self.shipment.client, 'RCV0015'))
          else
            validation_success(:quantity)
        end
      end
    end

    def valid_lot_number?
      validation_success(:lot_number)
    end

    def valid_coo?
      validation_success(:coo)
    end

    def valid_inner_pack?
      validation_success(:inner_pack)
    end

    def valid_purchase_order_nbr?
      validation_success(:purchase_order_nbr)
    end

    def valid_serial_nbr?
      if ! is_duplicate_serial_number?
        if shipment[:serial_nbr].size < shipment[:quantity].to_i
          validation_failed('424', :serial_nbr, 'Scan the next serial number')
        else
          validation_success(:serial_nbr)
        end
      end
    end

    private

    def is_duplicate_serial_number?
      serial_number = SerialNumber.where(client: shipment[:client], serial_nbr: shipment[:serial_nbr]).first
      if serial_number.present? || shipment[:serial_nbr].detect { |e| shipment[:serial_nbr].count(e) > 1 }.present?
        validation_failed('422', :serial_number, 'Serial number already exists')
        true
      end
      false
    end

    def is_received_quantity_not_matches_with_case? case_detail
      case_detail.quantity != self.shipment.quantity.to_i
    end

    def is_received_quantity_greater_than_shipped? shipment_details
      received_quantity = 0
      shipped_quantity = 0
      shipment_details.each do |shipment_detail|
        received_quantity += shipment_detail.received_qty.to_i
        shipped_quantity += shipment_detail.shipped_quantity.to_i
      end
      shipped_quantity < (received_quantity.to_i + self.shipment.quantity.to_i)
    end

    def yard_management_enabled?
      receive_configuration.Yard_Management == 't'
    end

    def Case_receiving_enabled?
      receive_configuration.Receiving_Type == CASE_RECEIVING
    end

    def SKU_receiving_enabled?
      receive_configuration.Receiving_Type == SKU_RECEIVING
    end

    def get_additional_info_for_case(case_detail)
      if Case_receiving_enabled?
        {case_id: case_detail.case_id, item: case_detail.item, quantity: case_detail.quantity}
      else
        {}
      end

    end

    def default_key
      {client: self.shipment[:client],
       warehouse: self.shipment[:warehouse],
       building: (self.shipment[:building].to_s.empty? ? nil : self.shipment[:building]),
       channel: (self.shipment[:channel].to_s.empty? ? nil : self.shipment[:channel])}
    end


    def receive_configuration
      GlobalConfiguration.get_configuration((default_key).merge({module: 'RECEIVING'}))
    end

    module ClassMethods
    end

  end
end