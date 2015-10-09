require 'utilities/response'
require 'utilities/utility'

module User
  
  class UserMasterMaintenance
    
    include Response
    include Utility
    attr_accessor :message, :error
    
    def initialize
      @message = {}
      @error = []
    end

    def get_users(basic_parameters:nil, filter_conditions:nil, expand:nil)

      if expand.nil?
        #user_header_data = [:id, :shipment_nbr, :asn_type, :ship_via, :record_status]
        user_header_data = '*'
      else
        user_header_data = '*'
      end

      user_hash = []
      user_headers = UserMaster.select(user_header_data).where(filter_conditions)
      user_headers.each { |user_header|
        #item_inner_pack = ItemInnerPack.where(client: item_header[:client], warehouse: item_header[:warehouse], building: item_header[:building], channel: item_header[:channel], item: item_header[:item])
        user_hash << {user_header: user_header}
      }
      user_hash
    end



    def add_user_master(app_parameters, fields_to_add)
      input_obj = app_parameters.merge(fields_to_add).to_hash
      if valid_data?(input_obj)
        p input_obj
        user_master_hash = UserMaster.new(input_obj)
        user_master_hash = add_derived_data(user_master_hash.clone)
        user_master_hash.save!
        resource_added_successfully("User #{user_master_hash.id}", "/user_master/#{user_master_hash.id}")
      end
      message
    end

    def update_user_master(app_parameters, id, fields_to_update)
       input_obj = app_parameters.merge(fields_to_update).merge(id: id).to_hash
       if valid_data?(input_obj)
         user= UserMaster.find(id)
         fields_to_update.each do |field, data|
            user.attributes =  {field => data}
         end   
         user.save!
         resource_updated_successfully("User #{id}")
        end  
        message 
    end
    
    def valid_data?(input_obj)
      true
    end

    def add_derived_data(user_master_hash)
      basic_parameters = {client: user_master_hash.client}
      user_master_hash
    end
      
  end
end