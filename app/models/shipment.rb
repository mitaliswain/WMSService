require 'concerns/receive_shipment'
class Shipment
  
  include ReceiveShipment
 
  def initialize
    @error  = []
    @success = []
  end
   
  def where(shipment)
     

    shipment_hash = Hash.new
    shipment_header = AsnHeader.where(client: shipment[:client], warehouse: shipment[:warehouse], channel: shipment[:channel], building: shipment[:building], shipment_nbr: shipment[:shipment_nbr]).first
    shipment_details = AsnDetail.where(client: shipment[:client], warehouse: shipment[:warehouse], channel: shipment[:channel], building: shipment[:building], shipment_nbr: shipment[:shipment_nbr])
    shipment_hash = {shipment_header:  shipment_header , shipment_detail: shipment_details}

    return shipment_hash   
    
  end
 
end