require 'active_support/concern'
module ValidationShipment
    extend ActiveSupport::Concern
  
 module ClassMethods
  
   def valid_location?(shipment)
        
        valid = true
        @location_master = LocationMaster.where(client: shipment[:client], warehouse: shipment[:warehouse], channel: shipment[:channel], building: shipment[:building], barcode: shipment[:location] ).first
        
        #Validating Location       
        case
          
        when @location_master.nil?
          @error << "Location " + shipment[:location] + " not found"
          valid = false
        
        when @location_master.location_type != "Pending" 
          @error <<"Can not receive to a non pending Location"
          valid = false
         
        when @location_master.record_status != "Empty"
          @error << "Can not receive to a non empty location"
          valid = false
        end
        
         return valid
     end
     
   def valid_itemmaster?(shipment)
     
     valid = true
     item_master = ItemMaster.where(client: shipment[:client], item: shipment[:item]).first
     
     #validating item
     
     case
     when item_master.nil? 
       @error << "Item " + shipment[:item] + " does not exist in Itemmaster"
       valid = false
     end
     
      return valid
      
    end
    
    
   def valid_shipment?(shipment)
      
      valid = true
      @shipment_header = AsnHeader.where(client: shipment[:client], warehouse: shipment[:warehouse], channel: shipment[:channel], building: shipment[:building], shipment_nbr: shipment[:shipment_nbr]).first
      
      #validating shipment information
    
      
      case 
        
      when @shipment_header.nil?
        @error << "Shipment " + shipment[:shipment_nbr] + " not found"
        valid = false
      end
       
       return valid 
    end
    
   def valid_shipment_details?(shipment)
      
      valid = true
      @shipment_details = AsnDetail.where(client: shipment[:client], warehouse: shipment[:warehouse], channel: shipment[:channel], building: shipment[:building], shipment_nbr: shipment[:shipment_nbr], item: shipment[:item]).first
      
      #validating shipment details
      
      case
      when @shipment_details.nil?
        @error << "Item " + shipment[:item] + " not found in this shipment"
        valid = false
      end
      
      return valid
    end
    
    def valid_existing_case?(shipment)
      
      valid = true
      @case = CaseHeader.where(client: shipment[:client], case_id: shipment[:case_id]).first
      
      #checking whether case exist or not
      
      case
      when !@case.nil?
        
        @error << "Case " + shipment[:case_id] + " already exists"
        valid = false
      end
      
      return valid
    end
 end    
end