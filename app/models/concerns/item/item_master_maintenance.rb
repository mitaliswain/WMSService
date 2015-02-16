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
      
  end
end