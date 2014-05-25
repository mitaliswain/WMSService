require 'concerns/receive_processing'
#require 'concerns/receive_validation'
class Shipment
  
  include ReceiveProcessing
  include ReceiveValidation
 
  attr_accessor :message, :error
  def initialize
    @message = {}
    @error = []
  end
  
  def receive_shipment(shipment)
   
    @configuration =  GlobalConfiguration.get_configuration(client: shipment[:client], warehouse: shipment[:warehouse], channel:  nil, building: nil, module: 'RECEIVING')

    # workflow = WorkFlow.get_workflow('RECEIVING')

    message = {status: true, message: []}   
    workflow = OpenStruct.new(
               {validate: [{ method: 'valid_location?' }, 
                           { method: 'valid_shipment?' },
                           { method: 'valid_case?' },
                           { method: 'valid_item?' },
                           { method: 'valid_received_quantity?' }
                          ],
                process:  [{ method: 'create_case' },
                           { method: 'update_shipment' },
                           { method: 'update_location' },
                           { method: 'update_innerpack_quantity'}
                          ],
                trigger:  [],
                house_keeping:  []
               })     
                  
    workflow.validate.each do |validate|
      message = Shipment.send(validate[:method], shipment)
      break unless message[:status] 
    end   
    return message unless message[:status]
    
    workflow.process.each do |process| 
      message = send(process[:method], shipment) 
      break unless message[:status] 
      
    end    
    return message unless message[:status]

    workflow.trigger.each do |trigger| 
      message = send(process[:method], shipment)
    end    
    return message unless message[:status]

    workflow.house_keeping.each do |process| 
      message = send(process[:method], shipment)
    end    

    return message unless message[:status]     
    
    
    @error << 'Shipment received successfully'  
    return { status: message[:status], message: @error}   
    
  end  
     
  def where(shipment)
     

    shipment_header = AsnHeader.where(client: shipment[:client], warehouse: shipment[:warehouse], channel: shipment[:channel], building: shipment[:building], shipment_nbr: shipment[:shipment_nbr]).first
    shipment_details = AsnDetail.where(client: shipment[:client], warehouse: shipment[:warehouse], channel: shipment[:channel], building: shipment[:building], shipment_nbr: shipment[:shipment_nbr])
    shipment_hash = { shipment_header:  shipment_header , shipment_detail: shipment_details }
  
    shipment_hash
  end
end
