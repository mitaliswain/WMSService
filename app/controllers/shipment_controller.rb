class ShipmentController < ApplicationController
  protect_from_forgery except: :index
  def index
     shipment_hash = []
     (Shipment.all(params[:client], params[:warehouse])).each do |shipment|
       shipment_hash << 
       Shipment.new.where(client: shipment.client,
                                   warehouse: shipment.warehouse,
                                   channel: shipment.channel,
                                   building: shipment.building,
                                   shipment_nbr: shipment.shipment_nbr)
     end
     render json: shipment_hash
  end

  def receive
    message = Shipment.new.receive_shipment(params[:shipment])
    render json: message
  end

  def show
    shipment = Shipment.new
    shipment_hash = shipment.where(client: params[:client],
                                   warehouse: params[:warehouse],
                                   channel: params[:channel],
                                   building: params[:building],
                                   shipment_nbr: params[:shipment_nbr])
    render json: shipment_hash
  end

  def update_header
    asn = AsnHeader.new
    message = asn.update_shipment_header(params[:app_parameters], params[:id], params[:fields_to_update])
    render json: message, status: message[:status]
  rescue Exception => e
    render json: asn.fatal_error(e.message), status: '500'    
  end
  
  def add_header
    asn = AsnHeader.new
    message = asn.add_shipment_header(params[:app_parameters], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
   rescue Exception => e
    render json: asn.fatal_error(e.message).to_json, status: '500'
  end

  def add_detail
    asn = AsnDetail.new
    message = asn.add_shipment_detail(params[:app_parameters], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
   rescue Exception => e
    render json: asn.fatal_error(e.message).to_json, status: '500'
  end


  def update_detail
    asn = AsnDetail.new
    message = asn.update_shipment_detail(params[:app_parameters], params[:id], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
   rescue Exception => e
    render json: asn.fatal_error(e.message).to_json, status: '500'
 
  end



  def validate
     valid_table = {
      'location' => 'valid_location?',
      'case' => 'valid_case?',
      'item' => 'valid_item?',
      'shipment_nbr' => 'valid_shipment?',
      'quantity' => 'valid_received_quantity?',
      #'inner_pack' => 'valid_inner_pack?'
    }
    
      if valid_table.key?(params[:to_valiadte])
          message = Shipment.send(valid_table[params[:to_valiadte]], params[:shipment]) 
      else  
          message = { status: false, message: ['Invalid validation requested'] }
      end

   render json: message
  end
   
end
