require 'yaml'
require 'active_support/concern'
module ReceiveValidation
  extend ActiveSupport::Concern

    
    SKU_RECEIVING = 'SKU'
    CASE_RECEIVING = 'Case'

    def is_valid_receive_data?(to_validate, shipment)
       
     valid_table = {
      'location' => 'valid_location?',
      'case' => 'valid_case?',
      'item' => 'valid_item?',
      'shipment_nbr' => 'valid_shipment?',
      'quantity' => 'valid_received_quantity?',
      'inner_pack' => 'valid_inner_pack?'
      }
      
      
      if valid_table.key?(to_validate)
          send(valid_table[to_validate], shipment) ? validation_success(to_validate) : false 
      else  
          invalid_request(:message, 'Invalid validation requested')
      end
    end
    
    
    def valid_location?(shipment)

      @location_master = LocationMaster.where(default_key shipment)
                                       .where(barcode: shipment[:location]).first
                                                                        
      return true   unless yard_management_enabled?(shipment)
      # Validating Location       
      
      case
      when !@location_master
        validation_failed('422', :location, Message.get_message(shipment[:client], 'RCV0001', [shipment[:location]]))
        
      when @location_master.location_type != 'Receiving'         
        validation_failed('422', :location, Message.get_message(shipment[:client], 'RCV0002', [shipment[:location]])) 
      
      #when @location_master.record_status != 'Empty' && !shipment[:shipment_nbr].blank? 
        #validation_failed('422', :location, Message.get_message(shipment[:client], 'RCV0003', [shipment[:location]])) 
      else
        true  
      end
             
   end
     

      
   def valid_shipment?(shipment) 
      @shipment_header = AsnHeader.where(default_key shipment)
                                  .where(shipment_nbr: shipment[:shipment_nbr]).first
      # validating shipment information
       
      case 
      when !@shipment_header
        validation_failed('422', :shipment_nbr, Message.get_message(shipment[:client], 'RCV0004', [shipment[:shipment_nbr]])) 

      when yard_management_enabled?(shipment) &&
        shipment[:location] !=  @shipment_header.door_door
        validation_failed('422', :shipment_nbr, Message.get_message(shipment[:client], 'RCV0005', [shipment[:shipment_nbr]])) 

      when @shipment_header.record_status!= 'Initiated' && @shipment_header.record_status!= 'Receiving in Progress'  
        validation_failed('422', :shipment_nbr, Message.get_message(shipment[:client], 'RCV0006', [shipment[:shipment_nbr]])) 
      else
        true
      end
               
   end
   
   def valid_case?(shipment)


      @case_header = CaseHeader.where(client: shipment[:client], case_id: shipment[:case_id]).first
      
      #checking whether case exist or not

      case        
      when !shipment[:case_id] || shipment[:case_id].blank?
        validation_failed('422', :case_id, Message.get_message(shipment[:client], 'RCV0007', [shipment[:case_id]])) 

      when  SKU_receiving_enabled?(shipment) && @case_header 
        validation_failed('422', :case_id, Message.get_message(shipment[:client], 'RCV0008', [shipment[:case_id]]))

      when  Case_receiving_enabled?(shipment) && !@case_header
        validation_failed('422', :case_id, Message.get_message(shipment[:client], 'RCV0009', [shipment[:case_id]]))

      when  Case_receiving_enabled?(shipment) && @case_header.record_status != 'Created' 
        validation_failed('422', :case_id, Message.get_message(shipment[:client], 'RCV0010', [shipment[:case_id]]))
      else
        true
      end
      
   end
    
   def valid_item?(shipment)

     @item_master = ItemMaster.where(client: shipment[:client], item: shipment[:item]).first
     @case_detail = CaseDetail.where(default_key shipment).where(item: shipment[:item]).first
     @shipment_detail = AsnDetail.where(default_key shipment)
                                 .where(shipment_nbr: shipment[:shipment_nbr], item: shipment[:item]).first
     
     #validating item
     
     case
     when !@item_master
       validation_failed('422', :item, Message.get_message(shipment[:client], 'RCV0011', [shipment[:item]]))

     when !@shipment_detail
        validation_failed('422', :item, Message.get_message(shipment[:client], 'RCV0012', [shipment[:item]]))

     when  Case_receiving_enabled?(shipment) && !@case_detail      
       validation_failed('422', :item, Message.get_message(shipment[:client], 'RCV0013', [shipment[:item]]))

     else
       true
     end

    end

    def valid_received_quantity?(shipment)
      
      if valid_item?(shipment)
        case 
   
        when is_received_quantity_matches_with_asn?(@case_detail, shipment)
           validation_failed('422', :item, Message.get_message(shipment[:client], 'RCV0014'))

        when is_received_quantity_greater_with_shipped?(@shipment_detail, shipment)
            validation_failed('422', :item, Message.get_message(shipment[:client], 'RCV0015'))
        else
          true    
        end
        
       else        
           false
      end
    end

   def valid_inner_pack?(shipment)
      true     
   end

   private    
   def is_received_quantity_matches_with_asn? case_detail, shipment    
      Case_receiving_enabled?(shipment) &&
      case_detail.quantity != shipment[:quantity].to_i     
   end
   
   def is_received_quantity_greater_with_shipped? shipment_detail, shipment   
      shipment_detail && 
      SKU_receiving_enabled?(shipment) &&          
      shipment_detail.shipped_quantity.to_i < (shipment_detail.received_qty.to_i + shipment[:quantity].to_i)
   end

   def yard_management_enabled? shipment    
      receive_configuration(shipment).Yard_Management == 't'  
   end
   
   def Case_receiving_enabled? shipment
     receive_configuration(shipment).Receiving_Type == CASE_RECEIVING  
   end

   def SKU_receiving_enabled? shipment
     receive_configuration(shipment).Receiving_Type == SKU_RECEIVING
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