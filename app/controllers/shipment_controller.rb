require 'utilities/response'
require 'utilities/utility'

class ShipmentController < ApplicationController

  protect_from_forgery except: :index
  before_action :authenticate_token!, :except => [:validate,:receive]
  
  include Utility
  include Parameters
  include Response

  def index
     filter_conditions = params[:filter_conditions]
     shipment_hash = Shipment::ShipmentMaintenance.new.get_shipments(basic_parameters: basic_parameters, filter_conditions: filter_conditions, expand: params[:expand])
     render json: shipment_hash
     rescue Exception => e
       shipment_hash.fatal_error(e.message)
       render json: shipment_hash.message.to_json, status: '500'
  end

  def show
    shipment = Shipment::ShipmentMaintenance.new
    filter_conditions = {id: params[:id]}
    shipment_hash = (shipment.get_shipments(filter_conditions: filter_conditions).first )
    render json: shipment_hash.to_json
  end

  def show_detail
    shipment = Shipment::ShipmentMaintenance.new
    filter_conditions = {id: params[:id]}
    detail_filter_conditions = {id: params[:detail_id]}
    shipment_hash = (shipment.get_shipment_detail(filter_conditions: filter_conditions, detail_filter_conditions: detail_filter_conditions)  )
    render json: shipment_hash.to_json
  end

  def add_header
    asn = Shipment::ShipmentMaintenance.new
    message = asn.add_shipment_header(params[:app_parameters], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
    rescue Exception => e
      asn.fatal_error(e.message)
      render json: asn.message.to_json, status: '500'

  end

  def update_header
    asn = Shipment::ShipmentMaintenance.new
    message = asn.update_shipment_header(params[:app_parameters], params[:id], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
   rescue Exception => e
    asn.fatal_error(e.message)
    render json: asn.message.to_json, status: '500'
  end

  def add_detail
    asn = asn = Shipment::ShipmentMaintenance.new
    message = asn.add_shipment_detail(params[:app_parameters], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
   rescue Exception => e
    asn.fatal_error(e.message)
    render json: asn.message.to_json, status: '500'
  end

  def update_detail
    asn = asn = Shipment::ShipmentMaintenance.new
    message = asn.update_shipment_detail(params[:app_parameters], params[:id], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
   rescue Exception => e
    asn.fatal_error(e.message)
    render json: asn.message.to_json, status: '500'
 
  end

  def validate
   shipment = Shipment::ShipmentReceive.new(params[:shipment])  
   shipment.is_valid_receive_data?(params[:to_validate])
   render json: shipment.message.to_json, status: shipment.message[:status]
  end
  
  def receive
    shipment = Shipment::ShipmentReceive.new(params[:shipment])
    shipment.receive_shipment
    render json: shipment.message.to_json, status: shipment.message[:status]
  end
  
   
end
