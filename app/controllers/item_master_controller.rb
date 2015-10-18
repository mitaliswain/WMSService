require 'utilities/response'
require 'utilities/utility'
  
class ItemMasterController < ApplicationController

  include Utility
  include Parameters
  include Response

  protect_from_forgery except: :index
    before_action :authenticate_token!
    
  def index
    begin
      filter_conditions = params[:filter_conditions]
      item = Item::ItemMasterMaintenance.new.get_items(basic_parameters: basic_parameters, filter_conditions: filter_conditions, expand: params[:expand])
      render json: item
    rescue Exception => e
      item.fatal_error(e.message)
      render json: item.message.to_json, status: '500'
    end
  end

  def show   
    filter_conditions = {id: params[:id]}
    item= Item::ItemMasterMaintenance.new.get_items(filter_conditions: filter_conditions).first 
    render json: item.to_json
    rescue Exception => e
      item.fatal_error(e.message)
      render json: item.message.to_json, status: '500'
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

end
