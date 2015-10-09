class AuthenticateController < ApplicationController

  def sign_in
     message =   UserMaster.sign_in(params[:user_details]["client"], params[:user_details]["user_id"],params[:user_details]["password"])
     render json: message.to_json, status: message[:status]
  rescue ActiveRecord::StatementInvalid => e
    render json: {error: 'Invalid Request Parameters'}.to_json, status: '500'
  end

end