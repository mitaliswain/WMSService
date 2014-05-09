require 'concerns/receive_shipment'
require 'concerns/validation_shipment'
class Shipment
  
  include ReceiveShipment
  include ValidationShipment::ClassMethods
 
  def initialize
    @error  = []
    @success = []
  end
  
  def receive_shipment(shipment)
      
      valid = valid_location?(shipment)
      valid = valid_shipment?(shipment) if(valid)
      valid = valid_shipment_details?(shipment) if(valid)
      valid = valid_existing_case?(shipment)  if(valid)
      valid = valid_itemmaster?(shipment)  if(valid)
      if  valid
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
   
  def where(shipment)
     

    shipment_hash = Hash.new
    shipment_header = AsnHeader.where(client: shipment[:client], warehouse: shipment[:warehouse], channel: shipment[:channel], building: shipment[:building], shipment_nbr: shipment[:shipment_nbr]).first
    shipment_details = AsnDetail.where(client: shipment[:client], warehouse: shipment[:warehouse], channel: shipment[:channel], building: shipment[:building], shipment_nbr: shipment[:shipment_nbr])
    shipment_hash = {shipment_header:  shipment_header , shipment_detail: shipment_details}

    return shipment_hash   
    
  end
 
end