require 'active_support/concern'
module ReceiveShipment
    extend ActiveSupport::Concern
    
   module ClassMethods
   end
   
  def receive_shipment(shipment)
      
     if  valid_location?(shipment[:client], shipment[:warehouse], shipment[:channel], shipment[:building], shipment[:location]) &&
         valid_shipment?(shipment[:client], shipment[:warehouse], shipment[:channel], shipment[:building], shipment[:shipment_nbr]) && 
         valid_shipment_details?(shipment[:client], shipment[:warehouse], shipment[:channel], shipment[:building], shipment[:shipment_nbr], shipment[:item], shipment[:quantity].to_i) &&
         valid_existing_case?(shipment[:client], shipment[:case_id]) &&
         valid_itemmaster?(shipment[:client], shipment[:item])
         
  
         #process shipment
         create_case(shipment[:case_id], shipment[:quantity].to_i)
         update_asnheader(shipment[:quantity])
         update_asndetails(shipment[:quantity])
         update_location(shipment[:quantity])
         update_innerpack_quantity(shipment[:client], shipment[:item], shipment[:innerpack_qty])
         
         
         
         @success << "Shipment received successfully"
         return @success
      else
        return @error
      end
    end
    
  def valid_location?(client, warehouse, channel, building, location)
        
        valid = true
        @location_master = LocationMaster.where(client: client, warehouse: warehouse, channel: channel, building: building, barcode: location ).first
        
        #Validating Location       
        case
          
        when @location_master.nil?
          @error << "Location " + location.to_s + " not found"
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
     
   def valid_itemmaster?(client, item)
     
     valid = true
     item_master = ItemMaster.where(client: client, item: item).first
     
     #validating item
     
     case
     when item_master.nil? 
       @error << "Item " + item + " does not exist in Itemmaster"
       valid = false
     end
     
      return valid
      
    end
    
    
   def valid_shipment?(client, warehouse, channel, building, shipment_nbr)
      
      valid = true
      @shipment_header = AsnHeader.where(client: client, warehouse: warehouse, channel: channel, building: building, shipment_nbr: shipment_nbr).first
      
      #validating shipment information
    
      
      case 
        
      when @shipment_header.nil?
        @error << "Shipment " + shipment_nbr + " not found"
        valid = false
      end
       
       return valid 
    end
    
   def valid_shipment_details?(client, warehouse, channel, building, shipment_nbr, item, quantity)
      
      valid = true
      @shipment_details = AsnDetail.where(client: client, warehouse: warehouse, channel: channel, building: building, shipment_nbr: shipment_nbr, item: item).first
      
      #validating shipment details
      
      case
      when @shipment_details.nil?
        @error << "Item " + item + " not found in this shipment"
        valid = false
      end
      
      return valid
    end
    
    def valid_existing_case?(client, case_id)
      
      valid = true
      @case = CaseHeader.where(client: client, case_id: case_id).first
      
      #checking whether case exist or not
      
      case
      when !@case.nil?
        
        @error << "Case " + case_id + " already exists"
        valid = false
      end
      
      return valid
    end
    
    def create_case(case_id, quantity)
      
      @case = CaseHeader.new
      
      @case.client = @shipment_header.client
      @case.warehouse = @shipment_header.warehouse
      @case.channel = @shipment_header.channel
      @case.building = @shipment_header.building
      @case.case_id = case_id
      @case.status = "created"
      @case.item = @shipment_details.item
      @case.quantity = quantity
      @case.shipment_nbr = @shipment_header.shipment_nbr
      @case.on_hold = 'Yes'
      @case.hold_code = 'Received'
      
      @case.save!
  
      rescue => error
      @error <<  error.to_s
      
    end
    
    def update_asnheader(quantity)
      @shipment_header.units_rcvd =  @shipment_header.units_rcvd.to_i + quantity.to_i
      @shipment_header.cases_rcvd = @shipment_header.cases_rcvd.to_i + 1
      @shipment_header.receiving_started_date = Time.now if @shipment_header.receiving_started_date.nil?
      
      @shipment_header.save!
      
       
      rescue => error
      @error <<  error.to_s
    end
   
   def update_asndetails(quantity)
     @shipment_details.received_qty =  @shipment_details.received_qty.to_i + quantity.to_i
     @shipment_details.cases_rcvd =  @shipment_details.cases_rcvd.to_i + quantity.to_i
     
     @shipment_details.save!
     
      
      rescue => error
      @error <<  error.to_s
   end
   
   def update_location(quantity)
     @location_master.record_status = "Occupied"
     @location_master.save!
     
     rescue => error
     @error << error.to_s
   end

   def update_innerpack_quantity(client, item, innerpack_qty)
      
      item_innerpacks = ItemInnerPack.where(client: client, item: item)
      
      if (lambda {

          item_innerpacks.each do |item_innerpack| 
              if item_innerpack.innerpack_qty.to_i == innerpack_qty.to_i                
                  return true
              end    
          end
          return false
          }).call == false
        
               new_item_innerpack = ItemInnerPack.create({client: client, item: item, innerpack_qty: innerpack_qty.to_i}) 
       else
                
       end     
     
     rescue => error
     @error << error.to_s
   end
     
    
end