module Utility
    def valid_app_parameters?(app_parameters)
      return set_invalid_message(:client)    if !app_parameters.has_key?(:client) || app_parameters [:client].nil? 
      return set_invalid_message(:warehouse) if !app_parameters.has_key?(:warehouse) || app_parameters [:warehouse].nil?     
      return set_invalid_message(:channel)   if !app_parameters.has_key?(:channel)
      return set_invalid_message(:building)  if !app_parameters.has_key?(:building)        
      set_valid_message
    end
  
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
  

  
end