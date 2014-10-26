module Shipment
  module ShipmentReceiveProcessing
    extend ActiveSupport::Concern
  
    def receive_shipment(shipment)
     
      @configuration =  GlobalConfiguration.get_configuration(client: shipment[:client], warehouse: shipment[:warehouse], channel:  nil, building: nil, module: 'RECEIVING')
      # workflow = WorkFlow.get_workflow('RECEIVING')
       process_workflow(shipment)      
    end  
     
  
    def create_case(shipment)
      
       if Case_receiving_enabled?(self.shipment)
         case_header = update_case_header(self.shipment)
         case_detail = update_case_detail(self.shipment , case_header)
       else
        case_header = create_case_header(self.shipment)
        case_detail = create_case_detail(self.shipment , case_header)
       end
       true
          
        rescue => error
        fatal_error(error.to_s)
    
     end
     
     def update_case_header(shipment)
       case_header = CaseHeader.where(default_key self.shipment)
                               .where(case_id: self.shipment.case_id).first
       case_header = get_case_header_info(case_header, self.shipment)    
       case_header.save!  
       case_header                                               
     end
      
     def create_case_header(shipment)
        case_header = CaseHeader.new
        case_header.client = self.shipment.client
        case_header.warehouse = self.shipment.warehouse
        case_header.channel = self.shipment.channel
        case_header.building = self.shipment.building
        case_header.case_id = self.shipment.case_id
        case_header.shipment_nbr = self.shipment.shipment_nbr
        case_header = get_case_header_info(case_header, self.shipment)
        case_header.save!
        case_header
     end
     
     def get_case_header_info(case_header, shipment)  
        location = LocationMaster.where(default_key self.shipment)
                                 .where(barcode: self.shipment.location).first
        asnheader = AsnHeader.where(default_key self.shipment)
                             .where(shipment_nbr: self.shipment.shipment_nbr).first
        case_header.record_status = 'Received'
        case_header.on_hold = 'Yes'
        case_header.hold_code = 'Putaway Required'
        case_header.barcode = self.shipment.location
        if location
          case_header.Location_type = location.location_type
          case_header.area = location.area
          case_header.zone = location.zone
          case_header.aisle = location.aisle
          case_header.bay = location.bay
          case_header.level = location.level
          case_header.position = location.position
        end
          
        # case_detail.total_weight = shipment[:quantity].to_i * item_master.unit_wgt
        # case_detail.total_volume = shipment[:quantity].to_i * item_master.unit_vol
    
        case_header.appointment_nbr = asnheader.appointment_nbr
        case_header.vendor_nbr = asnheader.vendor_nbr
        case_header.vendor_factory = asnheader.vendor_factory
        case_header.purchase_order_nbr = asnheader.purchase_order_nbr
        #case_header.multi_sku = shipment[:multi_sku] unless shipment[:multi_sku].nil?
        case_header.inner_pack_qty = self.shipment[:innerpack_qty]
        # case_detail.coveyable = item_master.coveyable
        case_header
        
    end
    
    def update_case_detail(shipment, case_header)
      case_detail = CaseDetail.where(default_key self.shipment)
                               .where(case_id: case_header.case_id, item: self.shipment.item).first
      case_detail = get_case_detail_info(case_detail, self.shipment)   
      case_detail.save!
      case_detail                             
    end
      
    def create_case_detail(shipment, case_header) 
        case_detail = CaseDetail.new 
        
        case_detail.client = self.shipment.client
        case_detail.warehouse = self.shipment.warehouse
        case_detail.channel = self.shipment.channel
        case_detail.building = self.shipment.building
        case_detail.case_id = self.shipment.case_id 
        case_detail.item = self.shipment.item
        case_detail.case_header_id = case_header.id
        case_detail.quantity = self.shipment.quantity.to_i
        case_detail = get_case_detail_info(case_detail, self.shipment)   
        case_detail.save!   
        case_detail
    end   
      
    def get_case_detail_info(case_detail, shipment)    
        item_master = ItemMaster.where(client: self.shipment.client, item: self.shipment.item).first
        asn_detail = AsnDetail.where(default_key self.shipment)
                              .where(shipment_nbr: self.shipment.shipment_nbr, item: self.shipment.item).first
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
        case_detail.inventory_type = item_master.inventory_type
        case_detail.poline_nbr = asn_detail.poline_nbr
        case_detail.shipment_nbr = self.shipment.shipment_nbr
        case_detail.coo = self.shipment.coo  unless self.shipment[:coo].nil?
        case_detail.serial_nbr = self.shipment.serial_nbr unless self.shipment[:serial_nbr].nil?
        
       # case_detail.climate_control = item_master.climate_control 
       # case_detail.perishable = item_master.perishable
       # case_detail.special_handling = item_master.special_handling 
        case_detail.record_status = 'Received'
        case_detail.unit_weight =  item_master.unit_wgt
        case_detail.unit_volume = item_master.unit_vol  
        case_detail
    end
        
    def update_shipment(shipment)
        shipment_header = update_asnheader(self.shipment)
        shipment_details = update_asndetails(self.shipment, shipment_header)
        
        true    
         
        rescue => error
        fatal_error(error.to_s)
        
    end  
        
    def update_asnheader(shipment)
        
        shipment_header = AsnHeader.where(default_key self.shipment)
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
       
    def update_asndetails(shipment, shipment_header)
        shipment_details = AsnDetail.where(default_key self.shipment)
                                    .where(shipment_nbr: self.shipment.shipment_nbr, item: self.shipment.item).first
        shipment_details.received_qty = shipment_details.received_qty.to_i + shipment[:quantity].to_i
        shipment_details.cases_rcvd = shipment_details.cases_rcvd.to_i + 1
        shipment_details.record_status = 'Receiving in Progress'
        shipment_details.receiver_comments = self.shipment.comments unless self.shipment[:comments].nil?
        shipment_details.save!      
        
     end
    
     def update_location(shipment)
        return true if !yard_management_enabled?(self.shipment)
        
        location_master = LocationMaster.where(default_key self.shipment)
                                        .where(barcode: self.shipment.location).first
    
        location_master.record_status = "Occupied"
        location_master.save!
        
        true
        
        rescue => error
        fatal_error(error.to_s)
    
     end
    
     def update_innerpack_quantity(shipment)
    
        item_innerpacks = ItemInnerPack.where(client: self.shipment.client, item: self.shipment.item)
        
          item_innerpack = ItemInnerPack.create(client: self.shipment.client, 
                               item: self.shipment.item, 
                               innerpack_qty: self.shipment.innerpack_qty.to_i) unless innerpack_exists? item_innerpacks , self.shipment
    
        true  
        
        rescue => error
        fatal_error(error.to_s)
     end
       
     private    
     def workflow
      workflow = 
             { validate: [{ method: 'valid_location?' }, 
                         { method: 'valid_shipment?' },
                         { method: 'valid_case?' },
                         { method: 'valid_item?' },
                         { method: 'valid_received_quantity?' }
                        ],
               process:  [{ method: 'create_case' },
                         { method: 'update_shipment' },
                         { method: 'update_location' },
                         { method: 'update_innerpack_quantity'}
                        ],
               trigger:  [],
               house_keeping:  []
              }    
    end  
    
    def process_workflow shipment
      workflow.each do |process, methods|
        methods.each do |method|
          response = self.send(method[:method], self.shipment)
          return self.message unless response 
        end
      end
       resource_processed_successfully(self.shipment.shipment_nbr, "Received Successfully")
    end 
     
    def innerpack_exists? item_innerpacks , shipment
         item_innerpacks.each do |item_innerpack| 
              return true if item_innerpack.innerpack_qty.to_i == self.shipment.innerpack_qty.to_i 
         end
         false                        
       end
       
     def default_key shipment
          { client:    self.shipment.client,
            warehouse: self.shipment.warehouse,
            building:  self.shipment.building.to_s.empty? ? nil : self.shipment.building,
            channel:   self.shipment.channel.to_s.empty?  ? nil : self.shipment.channel }
     end
       
     module ClassMethods
     end 
  end

end