require 'active_support/concern'
module ReceiveValidation
  extend ActiveSupport::Concern

  module ClassMethods

    def valid_location?(shipment)

      valid = true
      error =[]
      
      @configuration =  GlobalConfiguration.get_configuration(client: shipment[:client], warehouse: shipment[:warehouse], channel: nil, building: nil, module: 'RECEIVING')
      @location_master = LocationMaster.where(
                                        client: shipment[:client], warehouse: shipment[:warehouse],
                                        channel: nil, building: nil, barcode: shipment[:location]).first
      
      return { status: valid, message: error}   if @configuration.Yard_Management == 'f'

      # Validating Location       
      case

      when @location_master.nil?
        error << Message.get_message(shipment[:client], 'RCV0001', [shipment[:location]]) 
        valid = false
      
      when @location_master.location_type != 'Pending' 
        error << Message.get_message(shipment[:client], 'RCV0002', [shipment[:location]]) 
        valid = false

      when @location_master.record_status != 'Empty'
        error << Message.get_message(shipment[:client], 'RCV0003', [shipment[:location]]) 
        valid = false
    
      end
      { status: valid, message: error}         
   end
     
  
   def valid_shipment?(shipment)
      
      valid = true
      error =[]
      
      @shipment_header = AsnHeader.where(client: shipment[:client], warehouse: shipment[:warehouse], channel: nil, building: nil, shipment_nbr: shipment[:shipment_nbr]).first
      
      #validating shipment information
    
      case 
        
      when @shipment_header.nil?
        error << Message.get_message(shipment[:client], 'RCV0004', [shipment[:shipment_nbr]]) 
        valid = false
        
      when shipment[:location] !=  @shipment_header.first_recieve_dock_door
        error << Message.get_message(shipment[:client], 'RCV0005', [shipment[:shipment_nbr]]) 
        valid = false
        
      when @shipment_header.record_status!= 'Initiated'
        error << Message.get_message(shipment[:client], 'RCV0006', [shipment[:shipment_nbr]]) 
        valid = false
      else

      end
       
      return { status: valid, message: error}   
    end    
    
   def valid_case?(shipment)
      
      valid = true
      error =[]
      
      @configuration =  GlobalConfiguration.get_configuration(client: shipment[:client], warehouse: shipment[:warehouse], channel: nil, building: nil, module: 'RECEIVING')
      @case_header = CaseHeader.where(client: shipment[:client], case_id: shipment[:case_id]).first
      
      #checking whether case exist or not
      case
        
      when shipment[:case_id].nil? || shipment[:case_id].blank?
        error << Message.get_message(shipment[:client], 'RCV0007', [shipment[:case_id]]) 
        valid = false
        
      when  @configuration.Receiving_Type == "SKU" && !@case_header.nil? 
        
        error << Message.get_message(shipment[:client], 'RCV0008', [shipment[:case_id]]) 
        valid = false
        
      when  @configuration.Receiving_Type == "Case" && @case_header.nil? 
        
        error << Message.get_message(shipment[:client], 'RCV0009', [shipment[:case_id]])
        valid = false
        
      when  @configuration.Receiving_Type == "Case" && !@case_header.nil? && @case_header.record_status != 'Created' 
        
        error << Message.get_message(shipment[:client], 'RCV0010', [shipment[:case_id]])
        valid = false
        
      end
      
      { status: valid, message: error}  
    end
    
   def valid_item?(shipment)
     
      valid = true
      error =[]
      
     @configuration =  GlobalConfiguration.get_configuration(client: shipment[:client], warehouse: shipment[:warehouse], channel: nil, building: nil, module: 'RECEIVING')
     @item_master = ItemMaster.where(client: shipment[:client], item: shipment[:item]).first
     @case_detail = CaseDetail.where(client: shipment[:client], warehouse: shipment[:warehouse],
                                    channel: nil, building: nil, case_id: shipment[:case_id], item: shipment[:item]).first
     @shipment_details = AsnDetail.where(client: shipment[:client], warehouse: shipment[:warehouse], 
                                         channel: nil, building: nil, shipment_nbr: shipment[:shipment_nbr], item: shipment[:item]).first
     
     #validating item
     
     case
     when @item_master.nil? 
       error << Message.get_message(shipment[:client], 'RCV0010', [shipment[:item]])
       valid = false
     
     when @shipment_details.nil?
        error << "Item #{shipment[:item]} not found in this shipment"
        valid = false
       
     when @configuration.Receiving_Type == 'Case' && !@item_master.nil?  && @case_detail.nil?      
       error <<  "Item #{shipment[:item]} is not associated to this Case"
       valid = false
    
     end

    
     { status: valid, message: error}  
      
    end
    
    def valid_received_quantity?(shipment)
      
      valid = true
      error =[]
      
      message = valid_item?(shipment)
      if message[:status] 
        case 
           
        when @configuration.Receiving_Type == 'Case' && @case_detail.quantity != shipment[:quantity].to_i
           error << "Quantity entered does not match with the qty on the case"
           valid = false
           
        when @configuration.Receiving_Type == 'SKU' &&
             !@shipment_details.nil? && 
             @shipment_details.shipped_quantity < (@shipment_details.received_qty + shipment[:quantity].to_i)
             error << "Quantity received exceeds shipped quantity"
           valid = false
        end
       else
         
         valid = false 
         
      end
       { status: valid, message: error}  
    end
 end    
end