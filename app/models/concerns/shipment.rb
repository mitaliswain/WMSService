require 'utilities/utility'
require 'utilities/response'

class Shipment 
  
  include ShipmentReceiveProcessing
  include ShipmentReceiveValidation
  include Response
  include Utility
 
  attr_accessor :message, :error
  FAILED_TO_PROCESS = 'false'
  
  def initialize
    @message = {}
    @error = []
  end
  

  def self.all(client, warehouse, channel=nil, building=nil) 
    AsnHeader.where(client: client, warehouse: warehouse, channel: channel) 
  end
    
  def get_shipments(basic_parameters, filter_conditions, expand=nil)

    if expand.nil?
      #shipment_header_data = [:id, :shipment_nbr, :asn_type, :ship_via, :record_status]  
      #shipment_detail_data = [:id, :item, :shipped_quantity, :received_qty, :record_status]  
      shipment_header_data = '*'
      shipment_detail_data = '*'
    else
      shipment_header_data = '*'
      shipment_detail_data = '*'
    end
    
    basic_parameters[:building] =  basic_parameters[:building].blank? ? nil : basic_parameters[:building]
    basic_parameters[:channel] =  basic_parameters[:channel].blank? ? nil : basic_parameters[:channel] 

      
    shipment_headers = AsnHeader.select(shipment_header_data).where(basic_parameters).where(filter_conditions)
    shipment_hash = []
    shipment_headers.each do |shipment_header|
      shipment_details = AsnDetail.select(shipment_detail_data).where(asn_header_id: shipment_header.id)    
      shipment_hash << { shipment_header:  shipment_header , shipment_detail: shipment_details }
    end
    
    shipment_hash
  end
  
end
