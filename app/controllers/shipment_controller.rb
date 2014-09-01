class ShipmentController < ApplicationController
  protect_from_forgery except: :index
  def index
    render json: (Shipment.all(params[:client], params[:warehouse]))
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
    render json: asn.update_shipment_header(params[:app_parameters], params[:id], params[:fields_to_update])
    
  end
  
  def add_header
    asn = AsnHeader.new
    render json: asn.add_shipment_header(params[:app_parameters], params[:fields_to_update])
    
  end

  def update_detail
    shipment = params[:shipment]
    field_to_update = params[:field_to_update]
    shipment_hash = AsnDetail.find(params[:id])                
    shipment_hash.attributes =  {field_to_update[:column] => field_to_update[:value]}  
    shipment_hash.save
    render json: shipment_hash
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
