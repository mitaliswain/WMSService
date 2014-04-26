class ReceiveShipmentController < ApplicationController
  protect_from_forgery except: :index
  def index
    message = Hash.new
    message[:message] = "under constuction"
    render json: message
  end
  
  def create
   message = Hash.new
   shipment = Shipment.new
   message[:message] = shipment.receive_shipment(params[:client], params[:warehouse], params[:channel],params[:building], params[:shipment_nbr], params[:location], params[:case_id], params[:item], params[:quantity])
   render json: message
  end
  
end
