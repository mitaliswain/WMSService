require 'concerns/receive_processing'
#require 'concerns/receive_validation'
class Shipment
  
  include ReceiveProcessing
  include ReceiveValidation
 
  attr_accessor :message, :error
  FAILED_TO_PROCESS = 'false'
  
  def initialize
    @message = {}
    @error = []
  end
  
  def receive_shipment(shipment)
   
    @configuration =  GlobalConfiguration.get_configuration(client: shipment[:client], warehouse: shipment[:warehouse], channel:  nil, building: nil, module: 'RECEIVING')
    # workflow = WorkFlow.get_workflow('RECEIVING')
      process_workflow(shipment)      

  end  
  
  def process_workflow shipment
    workflow.each do |process, methods|
      methods.each do |method|
        self.message = Shipment.send(method[:method], shipment)
        return self.message unless message[:status] 
      end
    end
    self.message = { status: true, message: ['Shipment received successfully'] } 
  end
  
  def workflow
    workflow = 
           { validate: [{ method: 'valid_location?' }, 
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
            }    

  end  
  
  def process_workflow shipment
    workflow.each do |process, methods|
      methods.each do |method|
        self.message = Shipment.send(method[:method], shipment)
        return self.message unless message[:status] 
      end
    end
    self.message = { status: true, message: ['Shipment received successfully'] } 
  end
  
  def workflow
    workflow = 
           { validate: [{ method: 'valid_location?' }, 
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
            }    
  end  
  
  def self.all(client, warehouse, channel=nil, building=nil) 
    AsnHeader.where(client: client, warehouse: warehouse, channel: channel) 
  end
    
  def where(shipment_query)
     
    p shipment_query
    shipment_header = AsnHeader.where(shipment_query).first
    shipment_details = AsnDetail.where(asn_header_id: shipment_header.id)
    shipment_hash = { shipment_header:  shipment_header , shipment_detail: shipment_details }
  
    shipment_hash
  end
end
