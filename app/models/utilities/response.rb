module Response
=begin
 message structure for error
  { status: '422' ,
    message: 'Validation Failed' ,
    errors: [
      {code: '100',
       field: 'shipment_nbr',
       message: 'Shipment already exists'
      },
       {code: '404',
       field: 'ship via',
       message: 'Is not a valid Ship Via'
      } 
    ]
 } 
 
  message structure for valid request to create
   { status: '201' ,
    message: 'Shipment Created' ,
    content: [
      {code: '200',
       link: /shipment/21,
      }
    ]
   }
  
=end  
  
 def resource_added_successfully(resource, resource_link)
   @message = {status:  '201',
    message: "#{resource} Created Successfully",
    content: get_content(resource_link)
     }
   false  
 end 

 def resource_updated_successfully(resource)
   @message = {status:  '201',
    message: "#{resource} Updated Successfully",
     }
   true  
 end 
 
 def resource_processed_successfully(resource, message)
   @message = {status:  '201',
    message: "#{resource} #{message}",
     }
   true  
 end 
 


 def resource_deleted_successfully(resource)
   @message = {status:  '204',
    message: "#{resource} Deleted Successfully",
    }
   true 
 end   

 def resource_not_found(resource)
   @message = {status:  '404',
    message: "#{resource} not found"
    }
   false 
 end   

 def fatal_error(message, error_location=nil)
   @message = {status:  '500',
    message: message
    }
  Rails.logger.fatal("Critical: #{message} at #{error_location}")
   false
 end   


 def validation_failed(status_code, field_name, message)
  errors = @message.nil? || @message[:errors].nil? ? []:  @message[:errors]
  errors << {code: status_code,
             field: field_name,
             message: message
            }
    @message = { status: '422' ,
    message: 'Validation Failed' ,
    errors: errors    
 } 
 Rails.logger.warn("Warning: #{errors}")  
 false
 
end

def validation_success(field_name, *additional_info)
   
   @message = {status:  '200',
    message: 'Validation Successful',
    errors: [{
              code: '200',
              field: field_name,
              message: 'Validation Successful'
    }],
    additional_info: additional_info
    }   
   true
end

 def invalid_request(field_name, message)
     @message = {
       status:  '415',
       message: 'Invalid Request',
       errors: [{
              code: '415',
              field: field_name,
              message: message}]
    }   
   false
 end

private
def get_content(resource_link)
  if resource_link.nil?
    nil
  else
    [{
      code: '200',
      link: resource_link
    }]  
  end
end 
end