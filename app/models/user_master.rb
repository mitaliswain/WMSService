require '././lib/utilities/response'
require '././lib/utilities/json_web_token'

class UserMaster < ActiveRecord::Base

  include Response

  validates_uniqueness_of :user_id, scope: :client

  def self.sign_in(client, user_id, password)
    user = self.where(client: client).where(user_id: user_id).where(password: password).first

    if !user.nil?
      user_payload = {client: user.client, user_id: user.user_id, user_name: user.user_name,
                      preferred_warehouse: user.preferred_warehouse, authorized_warehouse: user.authorized_warehouse, authorized_action: user.authorized_action}
      validation_success({client: client, user_id: user_id}, {token: JsonWebToken.encode(user_payload)})
    else
      resource_not_found({client: client, user_id: user_id})
    end
    @message
  end


end
