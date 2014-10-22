class ConfigurationController < ApplicationController
  protect_from_forgery except: :index  
  def index
    render json: GlobalConfiguration.where(JSON.parse(params[:selection] || "{}")).to_json
  end
  
  def update
    configuration = WmsConfiguration::ConfigurationMaintenance.new
    message = configuration.update_configuration(params[:app_parameters], params[:id], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
   rescue Exception => e
    configuration.fatal_error(e.message)
    render json: configuration.message.to_json, status: '500'
  end

end