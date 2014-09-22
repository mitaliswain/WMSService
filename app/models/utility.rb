module Utility
    INVALID_FIELD = '422'
    def valid_app_parameters?(app_parameters)
      app_parameters = app_parameters.symbolize_keys
      if     (valid_client?(app_parameters)     ||
              valid_warehouse?(app_parameters)  ||
              valid_channel?(app_parameters)    ||
              valid_building?(app_parameters) )         
         true
      else
         false
      end   
    end
    
    def valid_client?(app_parameters)
       case 
         when !app_parameters.has_key?(:client) 
          validation_failed(INVALID_FIELD, :client, 'Client is missing')
          false
         when app_parameters[:client].nil?  
          validation_failed(INVALID_FIELD, :client, 'Client key has no value')
          false
         when app_parameters[:client] != 'WM' 
           validation_failed(INVALID_FIELD, :client, "#{app_parameters[:client]} : No such client exists")
           false
        else
          true   
       end  
    end
   
   def valid_warehouse?(app_parameters)
       case 
         when !app_parameters.has_key?(:warehouse) 
          validation_failed(INVALID_FIELD, :warehouse, 'Warehouse missing')
          false
         when app_parameters[:client].nil?  
          validation_failed(INVALID_FIELD, :warehouse, 'Warehouse has no value')
        else
          true   
       end  
    end 
   
   def valid_channel?(app_parameters)
     if !app_parameters.has_key?(:channel)
       validation_failed(INVALID_FIELD, :channel, 'Channel missing')
       false
     else
       true  
     end
   end
   
   def valid_building?(app_parameters)
     if !app_parameters.has_key?(:channel)
       validation_failed(INVALID_FIELD, :channel, 'Channel missing')
       false
     else
       true
     end  
   end
  
     
class ::Hash

  def method_missing(name)
    return self[name] if key? name
    self.each { |k,v| return v if k.to_s.to_sym == name }
    super.method_missing name
  end
end
  
end