class ConfigurationController < ApplicationController
  protect_from_forgery except: :index  
  def index
    begin
      filter_conditions = params[:filter_conditions]
      configuration_hash = WmsConfiguration::ConfigurationMaintenance.new.get_configuration(basic_parameters: basic_parameters, filter_conditions: filter_conditions, expand: params[:expand])
      render json: configuration_hash
    rescue ActiveRecord::StatementInvalid => e
      render json: {error: 'Invalid Request Parameters'}.to_json, status: '500'
    end
  end
  
  def update
    configuration = WmsConfiguration::ConfigurationMaintenance.new
    message = configuration.update_configuration(params[:app_parameters], params[:id], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
   rescue Exception => e
    configuration.fatal_error(e.message)
    render json: configuration.message.to_json, status: '500'
  end

  def basic_parameters
    basic_parameter = {client: params[:client], warehouse: params[:warehouse], channel: params[:channel], building: params[:building]}
    basic_parameter[:building] =  basic_parameter[:building].blank? ? nil : basic_parameter[:building]
    basic_parameter[:channel] =  basic_parameter[:channel].blank? ? nil : basic_parameter[:channel]
    basic_parameter
  end

end