module Shipment
	
	class ShipmentMaintenance
	  
	  include ShipmentMaintenanceHeader
    include ShipmentMaintenanceDetail
    include Response
    include Utility
	  attr_accessor :message, :error
	  
	  def initialize
      @message = {}
      @error = []
    end

    def add_shipment_header(app_parameters, fields_to_add)
      message=HeaderMaintenance.new.add_shipment_header(app_parameters, fields_to_add)
    end

    def update_shipment_header(app_parameters,id, fields_to_add)
      message=HeaderMaintenance.new.update_shipment_header(app_parameters, id, fields_to_add)
    end

    def add_shipment_detail(app_parameters, fields_to_add)
      message=DetailMaintenance.new.add_shipment_detail(app_parameters, fields_to_add)
    end

    def update_shipment_detail(app_parameters, id, fields_to_add)
      message=DetailMaintenance.new.update_shipment_detail(app_parameters, id, fields_to_add)
    end

	  def self.all(client, warehouse, channel=nil, building=nil)
	      AsnHeader.where(client: client, warehouse: warehouse, channel: channel) 
	  end

	  def get_shipments(basic_parameters:nil, filter_conditions:nil, expand:nil)

	      if expand.nil?
	        shipment_header_data = [:id, :shipment_nbr, :unit_ordered, :units_rcvd, :purchase_order_nbr, :record_status]  
	        shipment_detail_data = [:id, :item, :shipped_quantity, :received_qty, :record_status]  
	        #shipment_header_data = '*'
	        #shipment_detail_data = '*'
	      else
	        shipment_header_data = '*'
	        shipment_detail_data = '*'
	      end

	      shipment_headers = AsnHeader.select(shipment_header_data).where(basic_parameters).where(filter_conditions).order(:id)
	      shipment_hash = []
	      shipment_headers.each do |shipment_header|
	        shipment_details = AsnDetail.select(shipment_detail_data).where(asn_header_id: shipment_header.id)    
	        shipment_hash << { shipment_header:  shipment_header , shipment_detail: shipment_details }
	      end
	      
	      shipment_hash
		end

		def get_shipment_detail(filter_conditions:nil, detail_filter_conditions:nil)
			shipment_header = AsnHeader.where(filter_conditions).first
			shipment_detail = AsnDetail.where(asn_header_id: shipment_header.id).where(detail_filter_conditions).first
			shipment_hash = { shipment_header:  shipment_header , shipment_detail: shipment_detail }
			shipment_hash
		end
	end
end