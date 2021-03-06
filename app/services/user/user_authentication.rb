require 'utilities/response'
require 'utilities/utility'

module User
  
  class UserAuthentication
    
    include Response
    include JsonWebToken
    
  def sign_in(client, user_id, password)
   
    user = UserMaster.where(user_id: user_id).where(password: password).first

    if !user.nil?
      user_payload = {client: user.client, user_id: user.user_id, user_name: user.user_name,
                      preferred_warehouse: user.preferred_warehouse, authorized_warehouse: user.authorized_warehouse, authorized_action: user.authorized_action}
      validation_success({client: client, user_id: user_id}, {token: JsonWebToken.new.encode(user_payload)})
    else
      resource_not_found({client: client, user_id: user_id})
    end
    @message
  end
  
  end
  
end
    