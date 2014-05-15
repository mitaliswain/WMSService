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
   message[:status] = shipment.receive_shipment(client: params[:client], warehouse: params[:warehouse],
                                                channel: params[:channel],  building: params[:building],
                                                shipment_nbr: params[:shipment_nbr], location: params[:location], 
                                                case_id: params[:case_id], item: params[:item], quantity: params[:quantity],
                                                innerpack_qty: params[:innerpack_qty])
   
   message[:message] = shipment.error
   render json: message
  end
  
  def show
   
   shipment = Shipment.new
   shipment_hash = shipment.where(client: params[:client], warehouse: params[:warehouse], channel: params[:channel], building: params[:building], shipment_nbr: params[:shipment_nbr])
   render json: shipment_hash
  end

  def validate
    message = {status:true, message:''}
    case params[:to_valiadte]
      
    when 'location'
      shipment = Shipment.new
      message[:status] = shipment.valid_location?(params)
      message[:message] = shipment.error if !message[:status] 
     
    when 'case'
      shipment = Shipment.new
      message[:status] = shipment.valid_existing_case?(params)
      message[:message] = shipment.error if !message[:status] 

    when 'item'
      shipment = Shipment.new
      message[:status] = shipment.valid_itemmaster?(params)
      message[:status] = shipment.valid_shipment_details?(params) if message[:status]
      message[:message] = shipment.error if !message[:status] 

    when 'shipment_nbr'
      shipment = Shipment.new
      message[:status] = shipment.valid_shipment?(params)
      message[:message] = shipment.error if !message[:status] 

    else
      message[:status] = false
      message[:message] = 'Invalid validation requested'   
    end
    
    render json: message
  end
  
  
end
