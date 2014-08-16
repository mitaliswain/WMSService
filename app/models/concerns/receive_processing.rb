
module ReceiveProcessing
  extend ActiveSupport::Concern

  module ClassMethods
   def create_case(shipment)
      case_header = create_case_header(shipment)
      case_detail = create_case_detail(shipment , case_header)
  
      { status: true, message: [] }
  
      rescue => error
      { status: false, message: [error.to_s] }
  
     end
    
     def create_case_header(shipment)
      location = LocationMaster.where(default_key shipment)
                               .where(barcode: shipment[:location]).first
      asnheader = AsnHeader.where(default_key shipment)
                           .where(shipment_nbr: shipment[:shipment_nbr]).first
  
      case_header = CaseHeader.new
      case_header.client = shipment[:client]
      case_header.warehouse = shipment[:warehouse]
      case_header.channel = shipment[:channel]
      case_header.building = shipment[:building]
      case_header.case_id = shipment[:case_id]
      case_header.shipment_nbr = shipment[:shipment_nbr]
      case_header.status = 'created'
      case_header.on_hold = 'Yes'
      case_header.hold_code = 'Received'
      case_header.barcode = shipment[:location]
      case_header.Location_type = location.location_type
      case_header.area = location.area
      case_header.zone = location.zone
      case_header.aisle = location.aisle
      case_header.bay = location.bay
      case_header.level = location.level
      case_header.position = location.position
  
      # case_detail.total_weight = shipment[:quantity].to_i * item_master.unit_wgt
      # case_detail.total_volume = shipment[:quantity].to_i * item_master.unit_vol
  
      case_header.appointment_nbr = asnheader.appointment_nbr
      case_header.vendor_nbr = asnheader.vendor_nbr
      case_header.vendor_factory = asnheader.vendor_factory
      case_header.purchase_order_nbr = asnheader.purchase_order_nbr
      case_header.multi_sku = shipment[:multi_sku] unless shipment[:multi_sku].nil?
      case_header.inner_pack_qty = shipment[:inner_pack_qty]
      # case_detail.coveyable = item_master.coveyable
      case_header.save!
    end
    
    def create_case_detail(shipment , case_header)
      
      item_master = ItemMaster.where(client: shipment[:client], item: shipment[:item]).first
      asn_detail = AsnDetail.where(default_key shipment)
                            .where(shipment_nbr: shipment[:shipment_nbr], item: shipment[:item]).first
      case_detail = CaseDetail.new 
      case_detail.client = shipment[:client]
      case_detail.warehouse = shipment[:warehouse]
      case_detail.channel = shipment[:channel]
      case_detail.building = shipment[:building]
      case_detail.case_id = shipment[:case_id]   
      case_detail.item = shipment[:item]
      case_detail.quantity = shipment[:quantity].to_i
      case_detail.sku_attribute1 = item_master.sku_attribute1
      case_detail.sku_attribute2 =item_master.sku_attribute2
      case_detail.sku_attribute3 = item_master.sku_attribute3
      case_detail.sku_attribute4 = item_master.sku_attribute4
      case_detail.sku_attribute5 = item_master.sku_attribute5
      case_detail.sku_attribute6 = item_master.sku_attribute6
      case_detail.sku_attribute7 = item_master.sku_attribute7
      case_detail.sku_attribute8 = item_master.sku_attribute8
      case_detail.sku_attribute9 = item_master.sku_attribute9
      case_detail.sku_attribute10 = item_master.sku_attribute10
      case_detail.concept = item_master.concept
      case_detail.description = item_master.description
      case_detail.short_desc = item_master.short_desc
      case_detail.barcode = shipment[:location]
      case_detail.inventory_type = item_master.inventory_type
      case_detail.poline_nbr = asn_detail.poline_nbr
      case_detail.shipment_nbr = shipment[:shipment_nbr]
      case_detail.coo = shipment[:coo]  unless shipment[:coo].nil?
      case_detail.serial_nbr = shipment[:serial_nbr] unless shipment[:serial_nbr].nil?
      
     # case_detail.climate_control = item_master.climate_control 
     # case_detail.perishable = item_master.perishable
     # case_detail.special_handling = item_master.special_handling 
     
      case_detail.unit_weight =  item_master.unit_wgt
      case_detail.unit_volume = item_master.unit_vol
      
      case_detail.save!
  
    end
      
    def update_shipment(shipment)
      shipment_header = update_asnheader(shipment)
      shipment_details = update_asndetails(shipment, shipment_header)
      
      { status: true, message: [] }
       
      rescue => error
      { status: false, message: [error.to_s] }
      
    end  
      
    def update_asnheader(shipment)
      
      shipment_header = AsnHeader.where(default_key shipment)
                                 .where(shipment_nbr: shipment[:shipment_nbr]).first
      shipment_header.units_rcvd +=  shipment[:quantity].to_i
      shipment_header.cases_rcvd +=  1
      shipment_header.receiving_started_by = shipment[:user_id] unless shipment[:user_id].nil?
      shipment_header.receiving_started_date = Time.now if shipment_header.receiving_started_date.nil?
      shipment_header.first_recieve_dock_door ||= shipment[:location]
      shipment_header.door_door = shipment[:location]
      shipment_header.record_status = 'Receiving in Progress'
      
      shipment_header.save!
      
    end
     
    def update_asndetails(shipment, shipment_header)
      shipment_details = AsnDetail.where(default_key shipment)
                                  .where(shipment_nbr: shipment[:shipment_nbr], item: shipment[:item]).first
      shipment_details.received_qty += shipment[:quantity].to_i
      shipment_details.cases_rcvd += 1
      shipment_details.record_status = 'Receiving in Progress'
      shipment_details.receiver_comments = shipment[:comments] unless shipment[:comments].nil?
      shipment_details.save!      
      
     end
  
     def update_location(shipment)
  
      location_master = LocationMaster.where(default_key shipment)
                                      .where(barcode: shipment[:location]).first
  
      location_master.record_status = "Occupied"
      location_master.save!
      
      { status: true, message: [] }
  
      rescue => error
      { status: false, message: [error.to_s] }
  
     end
  
     def update_innerpack_quantity(shipment)
  
      item_innerpacks = ItemInnerPack.where(client: shipment[:client], item: shipment[:item])
      
        ItemInnerPack.create(client: shipment[:client], 
                             item: shipment[:item], 
                             innerpack_qty: shipment[:innerpack_qty].to_i) unless innerpack_exists? item_innerpacks , shipment
  
      { status: true, message: [] }
  
      rescue => error
      { status: false, message: [error.to_s] }
     end
     
     private    
     def innerpack_exists? item_innerpacks , shipment
       item_innerpacks.each do |item_innerpack| 
            return true if item_innerpack.innerpack_qty.to_i == shipment[:innerpack_qty].to_i 
       end
       false                        
     end
     
     def default_key shipment
        { client:    shipment[:client],
          warehouse: shipment[:warehouse],
          building: (shipment[:building].to_s.empty? ? nil : shipment[:building]),
          channel:  (shipment[:channel].to_s.empty?  ? nil : shipment[:channel]) }
     end
  
    end 
end