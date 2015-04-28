class LocationMasterController < ApplicationController
  require 'utilities/utility'

  include Utility

  protect_from_forgery except: :index
  def index
    begin
      render json:LocationMaster.where(params[:selection]).to_json
    rescue ActiveRecord::StatementInvalid => e
      invalid_request('selection','Invalid Selection Parameters' )
      render json: @message.to_json, status: @message[:status]
    end

  end

  def show
   location = LocationMaster.find(params[:id])
    render json: location.to_json
  end

  def update
   location = Location::LocationMasterMaintenance.new
    message = location.update_location_master(params[:app_parameters], params[:id], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
  rescue Exception => e
    location.fatal_error(e.message)
    render json: location.message.to_json, status: '500'
  end

  def create
    location = Location::LocationMasterMaintenance.new
    message = location.add_location_master(params[:app_parameters], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
  rescue Exception => e
   location.fatal_error(e.message)
    render json: location.message.to_json, status: '500'
  end
end
