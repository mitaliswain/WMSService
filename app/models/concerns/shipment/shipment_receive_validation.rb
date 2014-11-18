module Shipment
  require 'yaml'
  require 'active_support/concern'
  module ShipmentReceiveValidation
    extend ActiveSupport::Concern
  
      
      SKU_RECEIVING = 'SKU'
      CASE_RECEIVING = 'Case'
  
      def is_valid_receive_data?(to_validate, shipment)
         
       valid_table = {
        'location' => 'valid_location?',
        'case' => 'valid_case?',
        'item' => 'valid_item?',
        'shipment_nbr' => 'valid_shipment?',
        'purchase_order_nbr' => 'valid_purchase_order_nbr?',
        'quantity' => 'valid_received_quantity?',
        'inner_pack' => 'valid_inner_pack?'
        }
        
        
        if valid_table.key?(to_validate)
            send(valid_table[to_validate], shipment)
        else  
            invalid_request(:message, 'Invalid validation requested')
        end
      end
      
      
      def valid_location?(shipment)
  
        @location_master = LocationMaster.where(default_key self.shipment)
                                         .where(barcode: self.shipment.location).first
                                                                          
        #return validation_success(:location)    unless yard_management_enabled?(self.shipment)
        # Validating Location       
        case
        when !@location_master
          validation_failed('422', :location, Message.get_message(self.shipment.client, 'RCV0001', [self.shipment.location]))
          
        when @location_master.location_type != 'Receiving'       
          validation_failed('422', :location, Message.get_message(self.shipment.client, 'RCV0002', [self.shipment.location])) 
        
        #when @location_master.record_status != 'Empty' && !shipment[:shipment_nbr].blank? 
          #validation_failed('422', :location, Message.get_message(shipment[:client], 'RCV0003', [shipment[:location]])) 
        else
          validation_success(:location) 
        end
               
     end
       
  
        
     def valid_shipment?(shipment) 
        @shipment_header = AsnHeader.where(default_key self.shipment)
                                    .where(shipment_nbr: self.shipment.shipment_nbr).first
        # validating shipment information
         
        case 
        when !@shipment_header
          validation_failed('422', :shipment_nbr, Message.get_message(self.shipment.client, 'RCV0004', [self.shipment.shipment_nbr])) 
  
        when yard_management_enabled?(self.shipment) &&
          shipment[:location] !=  @shipment_header.door_door
          validation_failed('422', :shipment_nbr, Message.get_message(self.shipment.client, 'RCV0005', [self.shipment.shipment_nbr])) 
  
        when @shipment_header.record_status!= 'Initiated' && @shipment_header.record_status!= 'Receiving in Progress'  
          validation_failed('422', :shipment_nbr, Message.get_message(self.shipment.client, 'RCV0006', [self.shipment.shipment_nbr])) 
        else
          validation_success(:shipment_nbr)
        end
                 
     end
     
     def valid_case?(shipment)
  
  
        @case_header = CaseHeader.where(client: self.shipment.client, case_id: self.shipment.case_id).first
        case_detail = CaseDetail.where(case_id: @case_header.case_id).first if @case_header
        #checking whether case exist or not
  
        case        
        when !self.shipment.case_id || self.shipment.case_id.blank?
          validation_failed('422', :case_id, Message.get_message(self.shipment.client, 'RCV0007', [self.shipment.case_id])) 
  
        when  SKU_receiving_enabled?(self.shipment) && @case_header 
          validation_failed('422', :case_id, Message.get_message(self.shipment.client, 'RCV0008', [self.shipment.case_id]))
  
        when  Case_receiving_enabled?(self.shipment) && !@case_header
          validation_failed('422', :case_id, Message.get_message(self.shipment.client, 'RCV0009', [self.shipment.case_id]))
  
        when  Case_receiving_enabled?(self.shipment) && @case_header.record_status != 'Created' 
          validation_failed('422', :case_id, Message.get_message(self.shipment.client, 'RCV0010', [self.shipment.case_id]))
        else
          validation_success(:case_id, get_additional_info_for_case(case_detail))
        end
        
     end
      
     def valid_item?(shipment)
  
       @item_master = ItemMaster.where(client: self.shipment.client, item: self.shipment.item).first
       @case_detail = CaseDetail.where(default_key self.shipment).where(case_id: self.shipment.case_id, item: self.shipment.item).first
       shipment_detail = AsnDetail.where(default_key self.shipment)
                                   .where(shipment_nbr: self.shipment.shipment_nbr, item: self.shipment.item).first
       
       #validating item
       
       case
       when !@item_master
         validation_failed('422', :item, Message.get_message(self.shipment.client, 'RCV0011', [self.shipment.item]))
  
       when !shipment_detail
          validation_failed('422', :item, Message.get_message(self.shipment.client, 'RCV0012', [self.shipment.item]))
  
       when  Case_receiving_enabled?(self.shipment)  && !@case_detail    
  
         validation_failed('422', :item, Message.get_message(self.shipment.client, 'RCV0013', [self.shipment.item]))
  
       else
         validation_success(:item)
       end
  
      end
  
      def valid_received_quantity?(shipment)
        
        if valid_item?(self.shipment)
          @message = {}
          shipment_details = AsnDetail.where(default_key self.shipment)
                            .where(shipment_nbr: self.shipment.shipment_nbr, item: self.shipment.item)

          case 
     
          when Case_receiving_enabled?(self.shipment) && 
               is_received_quantity_not_matches_with_case?(@case_detail, shipment)
              validation_failed('422', :quantity, Message.get_message(self.shipment.client, 'RCV0014'))
  
          when is_received_quantity_greater_than_shipped?(shipment_details, shipment)
              validation_failed('422', :quantity, Message.get_message(self.shipment.client, 'RCV0015'))
          else
              validation_success(:quantity)    
          end
          
         else        
             false
        end
      end
  
     def valid_inner_pack?(shipment)
        validation_success(:inner_pack)     
     end
  
     def valid_purchase_order_nbr?(shipment)
        validation_success(:purchase_order_nbr)     
     end
  
     private    
     def is_received_quantity_not_matches_with_case? case_detail, shipment    
        case_detail.quantity != self.shipment.quantity.to_i     
     end
     
     def is_received_quantity_greater_than_shipped? shipment_details, shipment    
        received_quantity = 0
        shipped_quantity = 0
        shipment_details.each do |shipment_detail|
          received_quantity +=  shipment_detail.received_qty.to_i
          shipped_quantity += shipment_detail.shipped_quantity.to_i
        end     
        shipped_quantity < (received_quantity.to_i + self.shipment.quantity.to_i)
     end
  
     def yard_management_enabled? shipment    
        receive_configuration(self.shipment).Yard_Management == 't'  
     end
     
     def Case_receiving_enabled? shipment
       receive_configuration(self.shipment).Receiving_Type == CASE_RECEIVING  
     end
  
     def SKU_receiving_enabled? shipment
       receive_configuration(self.shipment).Receiving_Type == SKU_RECEIVING
     end
     
     def get_additional_info_for_case(case_detail)
       if Case_receiving_enabled?(self.shipment)
          {case_id: case_detail.case_id, item: case_detail.item, quantity: case_detail.quantity} 
       else
          {}
       end     
       
     end
  
     def default_key shipment
        { client:    shipment[:client],
          warehouse: shipment[:warehouse],
          building: (shipment[:building].to_s.empty? ? nil : shipment[:building]),
          channel:  (shipment[:channel].to_s.empty?  ? nil : shipment[:channel]) }
     end
     
  
     def receive_configuration shipment
        GlobalConfiguration.get_configuration((default_key shipment).merge({module: 'RECEIVING'}))
     end
     
   module ClassMethods
   end    
   
  end
end