require 'utilities/response'
require 'utilities/utility'

class UserMasterController < ApplicationController

  include Utility
  include Parameters
  include Response

  protect_from_forgery except: :index
  def index
    begin
      filter_conditions = params[:filter_conditions]
      user_hash = User::UserMasterMaintenance.new.get_users(basic_parameters: basic_parameters, filter_conditions: filter_conditions, expand: params[:expand])
      render json: user_hash
    rescue ActiveRecord::StatementInvalid => e
      render json: {error: 'Invalid Request Parameters'}.to_json, status: '500'
    end
  end

  def show
    user = User::UserMasterMaintenance.new
    filter_conditions = {id: params[:id]}
    user_hash = (user.get_users(filter_conditions: filter_conditions).first )
    render json: user_hash.to_json
  end

  def update
    user = User::UserMasterMaintenance.new
    message = user.update_user_master(params[:app_parameters], params[:id], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
  rescue Exception => e
    user.fatal_error(e.message)
    render json: user.message.to_json, status: '500'
    end

  def create
    user = User::UserMasterMaintenance.new
    message = user.add_user_master(params[:app_parameters], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
  rescue Exception => e
    user.fatal_error(e.message)
    render json: user.message.to_json, status: '500'
  end

  def basic_parameters
    basic_parameter = {client: params[:client]}
    basic_parameter
  end

end
