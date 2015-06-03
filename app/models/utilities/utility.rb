module Utility
    INVALID_FIELD = '422'

     def convert_blank_to_null_for_building_and_channel
        self.building = nil if self.building.blank?
        self.channel = nil if self.channel.blank?
     end
    
    def valid_app_parameters?(app_parameters)
      
      if     (valid_client?(app_parameters)     &&
              valid_warehouse?(app_parameters)  &&
              valid_channel?(app_parameters)    &&
              valid_building?(app_parameters) )         
         true
      else
         false
      end   
    end
    
    def valid_client?(app_parameters) 
       app_parameters = app_parameters.symbolize_keys
       case 
         when !app_parameters.has_key?(:client) 
          validation_failed(INVALID_FIELD, :client, 'Client is missing')
         when app_parameters[:client].nil?  
          validation_failed(INVALID_FIELD, :client, 'Client key has no value')
         when app_parameters[:client] != 'WM' 
           validation_failed(INVALID_FIELD, :client, "#{app_parameters[:client]} : No such client exists")
        else
          true   
       end  
    end
   
   def valid_warehouse?(app_parameters)
     app_parameters = app_parameters.symbolize_keys
       case 
         when !app_parameters.has_key?(:warehouse) 
          validation_failed(INVALID_FIELD, :warehouse, 'Warehouse missing')
         when app_parameters[:warehouse].nil?  
          validation_failed(INVALID_FIELD, :warehouse, 'Warehouse has no value')
        else
          true   
       end  
    end 
   
   def valid_channel?(app_parameters)
     app_parameters = app_parameters.symbolize_keys
     if !app_parameters.has_key?(:channel)
      validation_failed(INVALID_FIELD, :channel, 'Channel missing')
     else
        true  
     end
   end
   
   def valid_building?(app_parameters)
     app_parameters = app_parameters.symbolize_keys
     if !app_parameters.has_key?(:building)
       validation_failed(INVALID_FIELD, :building, 'Building missing')
     else
       true
     end  
   end 

   def get_next_one_up_number(basic_parameter, module_name)
         configuration = GlobalConfiguration.options(basic_parameter).options(module: module_name).get
         configuration.one_up_number = configuration.one_up_number.to_i + 1
         configuration.set
         configuration.one_up_number
   end  
   
 end
  
     
class ::Hash

  def method_missing(name)
    return self[name] if key? name
    self.each { |k,v| return v if k.to_s.to_sym == name }
    super.method_missing name
  end
end


class String
  def to_nil
    self.present? ? self : nil
  end
end