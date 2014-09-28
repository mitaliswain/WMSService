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
    shipment = Shipment.new 
    shipment.receive_shipment(params[:shipment])
    render json: shipment.message.to_json, status: shipment.message[:status]
  end

  def show
    shipment = Shipment.new
    shipment_hash = shipment.where(id: params[:id])
    render json: shipment_hash
  end

  def update_header
    asn = AsnHeader.new
    message = asn.update_shipment_header(params[:app_parameters], params[:id], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
   rescue Exception => e
    asn.fatal_error(e.message)
    render json: asn.message.to_json, status: '500'
  end
  
  def add_header
    asn = AsnHeader.new
    message = asn.add_shipment_header(params[:app_parameters], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
   rescue Exception => e
    asn.fatal_error(e.message)
    render json: asn.message.to_json, status: '500'
  end

  def add_detail
    asn = AsnDetail.new
    message = asn.add_shipment_detail(params[:app_parameters], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
   rescue Exception => e
    asn.fatal_error(e.message)
    render json: asn.message.to_json, status: '500'
  end


  def update_detail
    asn = AsnDetail.new
    message = asn.update_shipment_detail(params[:app_parameters], params[:id], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
   rescue Exception => e
    asn.fatal_error(e.message)
    render json: asn.message.to_json, status: '500'
 
  end

  def validate
   shipment = Shipment.new  
   shipment.is_valid_receive_data?(params[:to_validate], params[:shipment])
   render json: shipment.message
  end
   
end
