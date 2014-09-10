module Utility
    def valid_app_parameters?(app_parameters)
      return set_invalid_message(:client)    if !app_parameters.has_key?(:client) || app_parameters [:client].nil? 
      return set_invalid_message(:warehouse) if !app_parameters.has_key?(:warehouse) || app_parameters [:warehouse].nil?     
      return set_invalid_message(:channel)   if !app_parameters.has_key?(:channel)
      return set_invalid_message(:building)  if !app_parameters.has_key?(:building)        
      set_valid_message
    end
  
   def set_invalid_message(invalid_field)
      @message = { status: false, message: ["Invalid field: #{invalid_field}"] }
    end
  
    def set_valid_message(message=nil)
      @message = { status: true, message: ["validation pass: #{message}"] }
    end
  

  
end