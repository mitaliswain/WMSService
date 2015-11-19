require 'utilities/response'
require 'utilities/utility'

class LocationMasterController < ApplicationController
  
  include Utility
  include Parameters
  include Response

  protect_from_forgery except: :index
  def index
    begin
      filter_conditions = params[:filter_conditions]
      location = Location::LocationMasterMaintenance.new.get_locations(basic_parameters: basic_parameters, filter_conditions: filter_conditions, expand: params[:expand])
      render json: location
    #rescue Exception => e
     # location.fatal_error(e.message)
     # render json: location.message.to_json, status: '500'
    end
    
  end

  def show   
    filter_conditions = {id: params[:id]}
    location= Location::LocationMasterMaintenance.new.get_locations(filter_conditions: filter_conditions).first 
    render json: location.to_json
    rescue Exception => e
      location.fatal_error(e.message)
      render json: location.message.to_json, status: '500'
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
