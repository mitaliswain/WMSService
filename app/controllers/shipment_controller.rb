class ShipmentController < ApplicationController
  protect_from_forgery except: :index
  def index
    message = {}
    message[:message] = 'under constuction'
    render json: message
  end

  def receive
    message = Shipment.new.receive_shipment(params)
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

  def validate
     valid_table = {
      'location' => 'valid_location?',
      'case' => 'valid_existing_case?',
      'item' => 'valid_item?',
      'shipment_nbr' => 'valid_shipment?',
      'quantity' => 'valid_received_quantity?',
      'inner_pack' => 'valid_inner_pack?'
    }
    
      if valid_table.key?(params[:to_valiadte])
          message = Shipment.new.send(valid_table[params[:to_valiadte]], params) 
      else  
          message = { status: false, message: ['Invalid validation requested'] }
      end

   render json: message
  end
   
end
