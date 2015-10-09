class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_token!
    token = request.headers['authorization'] || params[:authorization]
    decode = JsonWebToken.decode(token)
  end

end
