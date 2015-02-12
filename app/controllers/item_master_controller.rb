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

=begin
  def update
    configuration = WmsConfiguration::ConfigurationMaintenance.new
    message = configuration.update_configuration(params[:app_parameters], params[:id], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
  rescue Exception => e
    configuration.fatal_error(e.message)
    render json: configuration.message.to_json, status: '500'
    end
=end
end
