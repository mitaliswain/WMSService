require 'concerns/receive_processing'
require 'concerns/receive_validation'
class Shipment
  
  include ReceiveProcessing
  include ReceiveValidation::ClassMethods
 
  attr_accessor :message, :error
  def initialize
    @message ={}
    @error =[]
  end
  
  def receive_shipment(shipment)
    
      valid = true
      @configuration =  GlobalConfiguration.get_configuration(client: shipment[:client], warehouse: shipment[:warehouse], channel:  nil, building: nil, module: "RECEIVING")
      
      message = valid_location?(shipment)
      message = valid_shipment?(shipment) if message[:status]
      message = valid_existing_case?(shipment)  if message[:status]
      message = valid_item?(shipment)  if message[:status]
      message = valid_received_quantity?(shipment) if message[:status]
      if message[:status]
         create_case(shipment[:case_id], shipment[:quantity].to_i)
         update_asnheader(shipment[:quantity], shipment[:location])
         update_asndetails(shipment[:quantity])
         update_location(shipment[:quantity])
         update_innerpack_quantity(shipment[:client], shipment[:item], shipment[:innerpack_qty])
         @error << "Shipment received successfully"
      end
      
      return { status: valid, message: @error}  
  end
   
  def where(shipment)
     

    shipment_header = AsnHeader.where(client: shipment[:client], warehouse: shipment[:warehouse], channel: shipment[:channel], building: shipment[:building], shipment_nbr: shipment[:shipment_nbr]).first
    shipment_details = AsnDetail.where(client: shipment[:client], warehouse: shipment[:warehouse], channel: shipment[:channel], building: shipment[:building], shipment_nbr: shipment[:shipment_nbr])
    shipment_hash = { shipment_header:  shipment_header , shipment_detail: shipment_details }
  
    shipment_hash
  end
end
