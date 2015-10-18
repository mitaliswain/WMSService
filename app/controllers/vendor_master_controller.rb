require 'utilities/response'
require 'utilities/utility'

class VendorMasterController < ApplicationController
  
  include Utility
  include Parameters
  include Response

  protect_from_forgery except: :index
  def index
    begin
      filter_conditions = params[:filter_conditions]
      vendor_hash = Vendor::VendorMasterMaintenance.new.get_items(basic_parameters: basic_parameters, filter_conditions: filter_conditions, expand: params[:expand])
      render json: vendor_hash
    rescue ActiveRecord::StatementInvalid => e
      render json: {error: 'Invalid Request Parameters'}.to_json, status: '500'
    end
  end

  def show
    item = Item::ItemMasterMaintenance.new
    filter_conditions = {id: params[:id]}
    item_hash = (item.get_items(filter_conditions: filter_conditions).first )
    render json: item_hash.to_json
  end

  def update
    item = Item::ItemMasterMaintenance.new
    message = item.update_item_master(params[:app_parameters], params[:id], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
  rescue Exception => e
    item.fatal_error(e.message)
    render json: item.message.to_json, status: '500'
  end

  def create
    item = Item::ItemMasterMaintenance.new
    message = item.add_item_master(params[:app_parameters], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
  rescue Exception => e
    item.fatal_error(e.message)
    render json: item.message.to_json, status: '500'
  end

  def basic_parameters
    basic_parameter = {client: params[:client], warehouse: params[:warehouse], channel: params[:channel], building: params[:building]}
    basic_parameter[:building] =  basic_parameter[:building].blank? ? nil : basic_parameter[:building]
    basic_parameter[:channel] =  basic_parameter[:channel].blank? ? nil : basic_parameter[:channel]
    basic_parameter
  end

end

