require 'active_support/concern'
module ReceiveValidation
  extend ActiveSupport::Concern

  module ClassMethods
    
    SKU_RECEIVING = 'SKU'
    CASE_RECEIVING = 'Case'

    
    def valid_location?(shipment)

      error =[]
      @location_master = LocationMaster.where(default_key shipment)
                                       .where(barcode: shipment[:location]).first
      return { status: true, message: error }   unless yard_management_enabled?(shipment)
      # Validating Location       
      case
      when !@location_master
        error << Message.get_message(shipment[:client], 'RCV0001', [shipment[:location]]) 
      
      when @location_master.location_type != 'Pending'         
        error << Message.get_message(shipment[:client], 'RCV0002', [shipment[:location]]) 
      
      when @location_master.record_status != 'Empty' && !shipment[:shipment_nbr].blank? 
        error << Message.get_message(shipment[:client], 'RCV0003', [shipment[:location]]) 
      end
      { status: (error.size > 0 ? false : true), message: error }         
   end
     
  
   def valid_shipment?(shipment)
     error =[]      
      @shipment_header = AsnHeader.where(default_key shipment)
                                  .where(shipment_nbr: shipment[:shipment_nbr]).first
      # validating shipment information
       
      case 
      when !@shipment_header
        error << Message.get_message(shipment[:client], 'RCV0004', [shipment[:shipment_nbr]]) 

      when yard_management_enabled?(shipment) &&
           shipment[:location] !=  @shipment_header.first_recieve_dock_door
        error << Message.get_message(shipment[:client], 'RCV0005', [shipment[:shipment_nbr]]) 

      when @shipment_header.record_status!= 'Initiated'
        error << Message.get_message(shipment[:client], 'RCV0006', [shipment[:shipment_nbr]]) 
      end
       
      { status: (error.size > 0 ? false : true), message: error }  
   end
   
   def valid_case?(shipment)

      error = []
      @case_header = CaseHeader.where(client: shipment[:client], case_id: shipment[:case_id]).first
      
      #checking whether case exist or not

      case        
      when !shipment[:case_id] || shipment[:case_id].blank?
        error << Message.get_message(shipment[:client], 'RCV0007', [shipment[:case_id]]) 

      when  SKU_receiving_enabled?(shipment) && @case_header 
        error << Message.get_message(shipment[:client], 'RCV0008', [shipment[:case_id]]) 

      when  Case_receiving_enabled?(shipment) && !@case_header
        error << Message.get_message(shipment[:client], 'RCV0009', [shipment[:case_id]])

      when  Case_receiving_enabled?(shipment) && @case_header.record_status != 'Created' 
        error << Message.get_message(shipment[:client], 'RCV0010', [shipment[:case_id]])
      end
      
      { status: (error.size > 0 ? false : true), message: error }   
   end
    
   def valid_item?(shipment)

     error =[]
     
     @item_master = ItemMaster.where(client: shipment[:client], item: shipment[:item]).first
     @case_detail = CaseDetail.where(default_key shipment).where(item: shipment[:item]).first
     @shipment_detail = AsnDetail.where(default_key shipment)
                                 .where(shipment_nbr: shipment[:shipment_nbr], item: shipment[:item]).first
     
     #validating item
     
     case
     when !@item_master
       error << Message.get_message(shipment[:client], 'RCV0011', [shipment[:item]])

     when !@shipment_detail
        error <<  Message.get_message(shipment[:client], 'RCV0012', [shipment[:item]])

     when  Case_receiving_enabled?(shipment) && !@case_detail      
       error <<  Message.get_message(shipment[:client], 'RCV0013', [shipment[:item]])

     end

     { status: (error.size > 0 ? false : true), message: error }      

    end

    def valid_received_quantity?(shipment)
      error =[]
      
      message = valid_item?(shipment)
      if message[:status]
        case 
   
        when is_received_quantity_matches_with_asn?(@case_detail, shipment)
           error <<  Message.get_message(shipment[:client], 'RCV0014')

        when is_received_quantity_greater_with_shipped?(@shipment_detail, shipment)
             error <<  Message.get_message(shipment[:client], 'RCV0015')
        end

       else        
             error << message[:error] 
      end
       { status: (error.size > 0 ? false : true), message: error }     
    end

   private    
   def is_received_quantity_matches_with_asn? case_detail, shipment    
      Case_receiving_enabled?(shipment) &&
      case_detail.quantity != shipment[:quantity].to_i     
   end
   
   def is_received_quantity_greater_with_shipped? shipment_detail, shipment   
      shipment_detail && 
      SKU_receiving_enabled?(shipment) &&          
      shipment_detail.shipped_quantity < (shipment_detail.received_qty + shipment[:quantity].to_i)
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
 end    
 
end