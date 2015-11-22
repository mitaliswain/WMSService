require 'jwt'

module JsonWebToken
   class JsonWebToken

     include Response
     
    def encode(payload, expiration = 1.hours.from_now)
      payload = payload.dup
      payload['exp'] = expiration.to_i
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end
  
    def decode(token)
      JWT.decode(token, Rails.application.secrets.secret_key_base).first
   end
  end
end