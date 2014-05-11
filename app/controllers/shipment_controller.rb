class ShipmentController < ApplicationController
  protect_from_forgery except: :index
  def index
    message = Hash.new
    message[:message] = "under constuction"
    render json: message
  end
  
  def receive
   message = Hash.new
   shipment = Shipment.new
   message[:valid] = shipment.receive_shipment(client: params[:client], warehouse: params[:warehouse], channel: params[:channel],
                                                 building: params[:building], shipment_nbr: params[:shipment_nbr], location: params[:location], 
                                                 case_id: params[:case_id], item: params[:item], quantity: params[:quantity], innerpack_qty: params[:innerpack_qty])
   
   message[:error] = shipment.error
   render json: message
  end
  
  def show
   
   shipment = Shipment.new
   shipment_hash = shipment.where(client: params[:client], warehouse: params[:warehouse], channel: params[:channel], building: params[:building], shipment_nbr: params[:shipment_nbr])
   render json: shipment_hash
  end

  def validate
    message = {}
    case params[:to_valiadte]
      
    when 'location'
      shipment = Shipment.new
      message[:valid] = shipment.valid_location?(params)
      message[:error] = shipment.error if !message[:valid] 
     
    when 'case'
      shipment = Shipment.new
      message[:valid] = shipment.valid_existing_case?(params)
      message[:error] = shipment.error if !message[:valid] 

    when 'item'
      shipment = Shipment.new
      message[:valid] = shipment.valid_itemmaster?(params)
      message[:valid] = shipment.valid_shipment_details?(params) if message[:valid]
      message[:error] = shipment.error if !message[:valid] 

    when 'shipment_nbr'
      shipment = Shipment.new
      message[:valid] = shipment.valid_shipment?(params)
      message[:error] = shipment.error if !message[:valid] 

    else
      message[:valid] = true   
    end
    
    render json: message
  end
  
  
end
