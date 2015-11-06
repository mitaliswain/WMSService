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

end
