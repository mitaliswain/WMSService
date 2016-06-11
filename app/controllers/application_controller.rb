require 'utilities/response'

class ApplicationController < ActionController::Base
  
  include Response
   
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_token!
    token = request.headers['authorization'] || params[:authorization]
    decode = JsonWebToken::JsonWebToken.new.decode(token)
  rescue Exception => e
      render json: invalid_token, status: '403'
  end


  def data_cache(key, time=2.minutes)

    return yield if caching_disabled?
    Rails.logger.warn(key)
    output = Rails.cache.fetch(key, {expires_in: time}) do
      yield
    end
    return output
  rescue
    # Execute the block if any error with Memcache

    return yield
  end

  def caching_disabled?
    ActionController::Base.perform_caching.blank?
  end

end
