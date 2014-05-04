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
   message[:message] = shipment.receive_shipment(client: params[:client], warehouse: params[:warehouse], channel: params[:channel],
                                                 building: params[:building], shipment_nbr: params[:shipment_nbr], location: params[:location], 
                                                 case_id: params[:case_id], item: params[:item], quantity: params[:quantity], innerpack_qty: params[:innerpack_qty])
   render json: message
  end
  
  def show
   
   shipment = Shipment.new
   shipment_hash = shipment.where(client: params[:client], warehouse: params[:warehouse], channel: params[:channel], building: params[:building], shipment_nbr: params[:shipment_nbr])
   render json: shipment_hash
  end
end
