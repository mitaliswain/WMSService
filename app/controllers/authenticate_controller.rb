class AuthenticateController < ApplicationController
  
  protect_from_forgery except: :index

  def sign_in
     message =   User::UserAuthentication.new.sign_in(params[:user_details]["client"], params[:user_details]["user_id"],params[:user_details]["password"])
     render json: message.to_json, status: message[:status]
  rescue Exception => e
    render json: {error: 'Invalid Request Parameters'}.to_json, status: '500'
  end

end