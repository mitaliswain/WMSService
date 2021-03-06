require 'utilities/response'
require 'utilities/utility'

class LocationTypeController < ApplicationController

  include Utility
  include Parameters
  include Response

    protect_from_forgery except: :index
    def index
      begin
        render json:LocationType.where(params[:selection]).to_json
      rescue ActiveRecord::StatementInvalid => e
        invalid_request('selection','Invalid Selection Parameters' )
        render json: @message.to_json, status: @message[:status]
      end

    end

    def show
      location_type = LocationType.find(params[:id])
      render json: location_type.to_json
    end

    def update
      location_type = Location::LocationTypeMaintenance.new
      message = location_type.update_location_type(params[:app_parameters], params[:id], params[:fields_to_update])
      render json: message.to_json, status: message[:status]
    rescue Exception => e
      location_type.fatal_error(e.message)
      render json: location_type.message.to_json, status: '500'
    end

    def create
      location_type = Location::LocationTypeMaintenance.new
      message = location_type.add_location_type(params[:app_parameters], params[:fields_to_update])
      render json: message.to_json, status: message[:status]
    rescue Exception => e
      location_type.fatal_error(e.message)
      render json: location_type.message.to_json, status: '500'
    end

end
