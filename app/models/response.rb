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
 end 

 def resource_updated_successfully(resource)
   @message = {status:  '204',
    message: "#{resource} Updated Successfully",
     }
 end 
 


 def resource_deleted_successfully(resource)
   @message = {status:  '204',
    message: "#{resource} Deleted Successfully",
    }
 end   

 def resource_not_found(resource)
   @message = {status:  '404',
    message: "#{resource} not found",
    }
 end   

 def validation_failed(status_code, field_name, message)
  errors = @message.nil? ? []:  @message[:errors]
  errors << {code: status_code,
             field: field_name,
             message: message
            }
   @message = { status: '422' ,
    message: 'Validation Failed' ,
    errors: errors
    
 } 
 end
 
 def message
   @message
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