module Shipment
  module ShipmentReceiveProcessing
  
    def receive_shipment
     
      @configuration =  GlobalConfiguration.get_configuration(client: self.shipment[:client], warehouse: self.shipment[:warehouse], channel:  nil, building: nil, module: 'RECEIVING')
      # workflow = WorkFlow.get_workflow('RECEIVING')
      ActiveRecord::Base.transaction do
        begin
          process_workflow
        rescue => error
          fatal_error(error.to_s, error.backtrace[0])
          raise ActiveRecord::Rollback
          return self.message
        end
      end
    end  
     
  
    def create_case
      
       if Case_receiving_enabled?
         case_header = update_case_header
         case_detail = update_case_detail(case_header)
       else
        case_header = create_case_header
        case_detail = create_case_detail(case_header)
       end
       true
    
     end
     
     def update_case_header
       case_header = CaseHeader.where(default_key)
                               .where(case_id: self.shipment.case_id).first
       case_header = get_case_header_info(case_header)
       case_header.save!  
       case_header                                               
     end
      
     def create_case_header
        case_header = CaseHeader.new
        case_header.client = self.shipment.client
        case_header.warehouse = self.shipment.warehouse
        case_header.channel = self.shipment.channel
        case_header.building = self.shipment.building
        case_header.case_id = self.shipment.case_id
        case_header.shipment_nbr = self.shipment.shipment_nbr
        case_header = get_case_header_info(case_header)
        case_header.save!
        case_header
     end
     
     def get_case_header_info(case_header)
        location = LocationMaster.where(default_key)
                                 .where(barcode: self.shipment.location).first
        asn_header = AsnHeader.where(default_key)
                             .where(shipment_nbr: self.shipment.shipment_nbr).first
        asn_detail = get_asn_detail_for_the_current_case

        case_header.record_status = 'Received'
        case_header.on_hold = 'Yes'
        case_header.hold_code = 'Putaway Required'
        if location
          case_header.location_type = location.location_type
          case_header.location = location.barcode
        end
          
        # case_detail.total_weight = shipment[:quantity].to_i * item_master.unit_wgt
        # case_detail.total_volume = shipment[:quantity].to_i * item_master.unit_vol
    
        case_header.appointment_nbr = asn_header.appointment_nbr
        case_header.vendor_nbr = asn_header.vendor_nbr
        case_header.vendor_factory = asn_header.vendor_factory
        case_header.purchase_order_nbr = asn_detail.purchase_order_nbr
        #case_header.multi_sku = shipment[:multi_sku] unless shipment[:multi_sku].nil?
        case_header.inner_pack_qty = self.shipment[:innerpack_qty]
        case_header.coo = self.shipment.coo unless self.shipment[:coo].nil?
        # case_detail.coveyable = item_master.coveyable
        case_header
        
     end

    
    def update_case_detail(case_header)
      case_detail = CaseDetail.where(default_key)
                               .where(case_id: case_header.case_id, item: self.shipment.item).first
      case_detail = get_case_detail_info(case_detail)
      case_detail.save!
      case_detail                             
    end
      
    def create_case_detail(case_header)
        case_detail = CaseDetail.new 
        
        case_detail.client = self.shipment.client
        case_detail.warehouse = self.shipment.warehouse
        case_detail.channel = self.shipment.channel
        case_detail.building = self.shipment.building
        case_detail.case_id = self.shipment.case_id 
        case_detail.item = self.shipment.item
        case_detail.case_header_id = case_header.id
        case_detail.quantity = self.shipment.quantity.to_i
        case_detail = get_case_detail_info(case_detail)
        case_detail.save!   
        case_detail
    end   
      
    def get_case_detail_info(case_detail)
        item_master = ItemMaster.where(client: self.shipment.client, item: self.shipment.item).first
        asn_detail = get_asn_detail_for_the_current_case
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
        case_detail.barcode = self.shipment.location
        case_detail.poline_nbr = asn_detail.poline_nbr
        #case_detail.serial_nbr = self.shipment.serial_nbr unless self.shipment[:serial_nbr].nil?
        
       # case_detail.climate_control = item_master.climate_control 
       # case_detail.perishable = item_master.perishable
       # case_detail.special_handling = item_master.special_handling 
        case_detail.record_status = 'Received'
        case_detail.unit_weight =  item_master.unit_wgt
        case_detail.unit_volume = item_master.unit_vol
        case_detail
    end
  
        
    def update_shipment
        shipment_header = update_asnheader
        shipment_details = update_asndetails(shipment_header)
        
        true
        
    end  
        
    def update_asnheader
        
        shipment_header = AsnHeader.where(default_key)
                                   .where(shipment_nbr: self.shipment.shipment_nbr).first
        #shipment_header.units_rcvd =  shipment_header.units_rcvd.to_i + shipment[:quantity].to_i
        #shipment_header.cases_rcvd =  shipment_header.cases_rcvd.to_i + 1
        shipment_header.receiving_started_by = self.shipment.user_id unless self.shipment[:user_id].nil?
        shipment_header.receiving_started_date = Time.now if shipment_header.receiving_started_date.nil?
        shipment_header.first_recieve_dock_door ||= self.shipment.location
        shipment_header.door_door = self.shipment.location
        shipment_header.record_status = 'Receiving in Progress'
        
        shipment_header.save!
        
    end
       
    def update_asndetails(shipment_header)
             shipment_detail = get_asn_detail_for_the_current_case
             shipment_detail.received_qty = shipment_detail.received_qty.to_i + shipment[:quantity].to_i
             shipment_detail.cases_rcvd = shipment_detail.cases_rcvd.to_i + 1
             shipment_detail.record_status = 'Receiving in Progress'
             shipment_detail.receiver_comments = self.shipment.comments unless self.shipment[:comments].nil?
             shipment_detail.save!  
     end
    
     def update_location
        return true if !yard_management_enabled?
        
        location_master = LocationMaster.where(default_key)
                                        .where(barcode: self.shipment.location).first
    
        location_master.record_status = "Occupied"
        location_master.save!
        
        true

     end
    
     def update_innerpack_quantity
    
        item_inner_packs = ItemInnerPack.where(default_key)

        if ! innerpack_exists? item_inner_packs

          item_master = ItemMaster.where(client: self.shipment.client).where(item: self.shipment.item).first
          item_inner_pack = ItemInnerPack.new
          item_inner_pack.client = item_master.client
          item_inner_pack.warehouse = item_master.warehouse
          item_inner_pack.building = item_master.building
          item_inner_pack.channel = item_master.channel
          item_inner_pack.item = item_master.item
          item_inner_pack.innerpack_qty = self.shipment.innerpack_qty.to_i
          item_inner_pack.innerpack_wgt = self.shipment.innerpack_qty.to_i * item_master.unit_wgt
          item_inner_pack.innerpack_vol = self.shipment.innerpack_qty.to_i * item_master.unit_wgt
          item_inner_pack.innerpack_len = self.shipment.innerpack_qty.to_i * item_master.unit_len

          item_inner_pack.save!
        end
        true  

     end

    def create_serial_nbr
      return true unless self.shipment.has_key?(:serial_nbr)
       self.shipment.serial_nbr.each do |serial|
         serial_number = SerialNumber.new
         serial_number.serial_nbr = serial
         serial_number.client = self.shipment.client
         serial_number.case_id = self.shipment.case_id
         serial_number.item_barcode = self.shipment.item
         serial_number.purchase_order_nbr = self.shipment.purchase_order_nbr if self.shipment.has_key?(:purchase_order_nbr)
         serial_number.lot_nbr = self.shipment.lot_number  if self.shipment.has_key?(:lot_number)
         serial_number.shipment_nbr = self.shipment.shipment_nbr
         serial_number.coo = self.shipment.coo if self.shipment.has_key?(:coo)
         serial_number.status = 'Received'
         serial_number.save!
        end
       true
    end
       
     private    
     def workflow
      workflow = 
             { validate: [{method: 'valid_location?' },
                         { method: 'valid_shipment?' },
                         { method: 'valid_case?' },
                         { method: 'valid_item?' },
                         { method: 'valid_received_quantity?' }
                        ],
               process:  [{ method: 'create_case' },
                         { method: 'update_shipment' },
                         { method: 'update_location' },
                         { method: 'update_innerpack_quantity'},
                         { method: 'create_serial_nbr'}

                        ],
               trigger:  [],
               house_keeping:  []
              }    
    end  

    def process_workflow
          workflow.each do |process, methods|
            methods.each do |method|
              response = self.send(method[:method])
              return self.message unless response
            end
          end
       resource_processed_successfully(self.shipment.shipment_nbr, "Received Successfully")
    end

    def get_asn_detail_for_the_current_case
      shipment_details = AsnDetail.where(default_key)
                             .where(shipment_nbr: self.shipment.shipment_nbr, item: self.shipment.item)
                             .order(:sequence)
      shipment_details.each do |shipment_detail|
        if shipment_detail.shipped_quantity.to_i > shipment_detail.received_qty.to_i
          return shipment_detail
        end
      end
    end

    def innerpack_exists? item_innerpacks
         item_innerpacks.each do |item_innerpack| 
              return true if item_innerpack.innerpack_qty.to_i == self.shipment.innerpack_qty.to_i 
         end
         false                        
       end
       
     def default_key
          { client:    self.shipment.client,
            warehouse: self.shipment.warehouse,
            building:  self.shipment.building.to_s.empty? ? nil : self.shipment.building,
            channel:   self.shipment.channel.to_s.empty?  ? nil : self.shipment.channel }
     end
       
     module ClassMethods
     end 
  end

end