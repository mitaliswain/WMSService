require 'utilities/response'
require 'utilities/utility'

module Item
  
  class ItemMasterMaintenance
    
    include Response
    include Utility
    attr_accessor :message, :error
    
    def initialize
      @message = {}
      @error = []
    end

    def get_items(basic_parameters:nil, filter_conditions:nil, expand:nil)

      if expand.nil?
        #item_header_data = [:id, :shipment_nbr, :asn_type, :ship_via, :record_status]
        item_header_data = '*'
      else
        item_header_data = '*'
      end

      item_hash = []
      item_headers = ItemMaster.select(item_header_data).where(filter_conditions)
      item_headers.each { |item_header|
        item_inner_pack = ItemInnerPack.where(client: item_header[:client], warehouse: item_header[:warehouse], building: item_header[:building], channel: item_header[:channel], item: item_header[:item])
        item_hash << {item_header: item_header, item_inner_pack: (item_inner_pack || [])}
      }
      item_hash
    end



    def add_item_master(app_parameters, fields_to_add)
      input_obj = app_parameters.merge(fields_to_add).to_hash
      if valid_data?(input_obj) && valid_app_parameters?(input_obj)
        item_master_hash = ItemMaster.new(input_obj)
        item_master_hash = add_derived_data(item_master_hash.clone)
        item_master_hash.save!
        resource_added_successfully("Item #{item_master_hash.id}", "/item_master/#{item_master_hash.id}")
      end
      message
    end

    def update_item_master(app_parameters, id, fields_to_update)
       input_obj = app_parameters.merge(fields_to_update).merge(id: id).to_hash
       if valid_app_parameters?(input_obj) && valid_data?(input_obj)
         item = ItemMaster.find(id)
         fields_to_update.each do |field, data|
            item.attributes =  {field => data}
         end   
         item.save!
         resource_updated_successfully("Item #{id}")
        end  
        message 
    end
    
    def valid_data?(input_obj)
      true
    end

    def add_derived_data(item_master_hash)
      item_master_hash
    end
      
  end
end