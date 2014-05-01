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
   message[:message] = shipment.receive_shipment(params[:client], params[:warehouse], params[:channel],params[:building], params[:shipment_nbr], params[:location], params[:case_id], params[:item], params[:quantity])
   render json: message
  end
  
  def show
   
   shipment = Shipment.new
   shipment_hash = shipment.where(client: params[:client], warehouse: params[:warehouse], channel: params[:channel], building: params[:building], shipment_nbr: params[:shipment_nbr])
   render json: shipment_hash
  end
end
