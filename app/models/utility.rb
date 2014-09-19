module Utility
    INVALID_FIELD = '422'
    def valid_app_parameters?(app_parameters)
      if     (valid_client?(app_parameters) ||
              valid_warehouse?(app_parameters) ||
              valid_channel?(app_parameters) ||
              valid_building?(app_parameters) 
            )         
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
       validation_failed(:channel, 'Channel missing')
       false
     else
       true
     end  
   end
  
     
    
=begin  
   def set_error_message(custom_message=nil)
      message = @message.nil? ? [] : @message[:message] 
      message << {error: custom_message}
      @message = { status: false, message: message} 
      @message  
   end
   
   def set_invalid_message(invalid_field, custom_message=nil)
      message = @message.nil? ? [] : @message[:message]
      message << {field: invalid_field, msg: "Invalid field: #{custom_message}"}
      @message = { status: false, message: message, validation_failure: message} 
      @message
    end
  
    def set_valid_message(message=nil)
      @message = { status: true, message: [], validation_failure: [] }
    end
  
=end
  
end