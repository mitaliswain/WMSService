class ItemMasterController < ApplicationController

  require 'utilities/utility'

  include Utility

  protect_from_forgery except: :index
  def index
    begin
      render json: ItemMaster.where(params[:selection]).to_json
    rescue ActiveRecord::StatementInvalid => e
      invalid_request('selection','Invalid Selection Parameters' )
      render json: @message.to_json, status: @message[:status]
    end

  end

  def show
    item = ItemMaster.find(params[:id])
    render json: item.to_json
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
  #rescue Exception => e
   # item.fatal_error(e.message)
   # render json: item.message.to_json, status: '500'
  end
end
