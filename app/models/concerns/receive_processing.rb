
module ReceiveProcessing
    extend ActiveSupport::Concern
    
   module ClassMethods
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
    
    def update_asnheader(quantity, location)
      @shipment_header.units_rcvd =  @shipment_header.units_rcvd.to_i + quantity.to_i
      @shipment_header.cases_rcvd = @shipment_header.cases_rcvd.to_i + 1
      @shipment_header.receiving_started_date = Time.now if @shipment_header.receiving_started_date.nil?
      @shipment_header.first_recieve_dock_door = location
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