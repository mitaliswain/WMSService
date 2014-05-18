class ShipmentController < ApplicationController
  protect_from_forgery except: :index
  def index
    message = {}
    message[:message] = 'under constuction'
    render json: message
  end

  def receive
    message = {}
    shipment = Shipment.new
    message[:status] = shipment.receive_shipment(params)
    message[:message] = shipment.error
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
    message = {}
    case params[:to_valiadte]

    when 'location'
      message = Shipment.new.valid_location?(params)

    when 'case'
      message = Shipment.new.valid_existing_case?(params)

    when 'item'
      message = Shipment.new.valid_item?(params)
    
    when 'shipment_nbr'

      message = Shipment.new.valid_shipment?(params)
   
   when 'quantity'
     
     message = Shipment.new.valid_received_quantity?(params)
     
   when 'inner_pack'  
      message = { status: true, message: [''] }
   else
      
     message = { status: false, message: ['Invalid validation requested'] }
   end

   render json: message
  end
end
