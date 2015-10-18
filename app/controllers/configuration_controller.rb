require 'utilities/response'
require 'utilities/utility'

class ConfigurationController < ApplicationController
  
  include Utility
  include Parameters
  include Response
  
  protect_from_forgery except: :index
  before_action :authenticate_token!
  
  
  def index
    begin
      filter_conditions = params[:filter_conditions]
      configuration_hash = WmsConfiguration::ConfigurationMaintenance.new.get_configurations(basic_parameters: basic_parameter, filter_conditions: filter_conditions, expand: params[:expand])
      render json: configuration_hash
    rescue ActiveRecord::StatementInvalid => e
      render json: {error: 'Invalid Request Parameters'}.to_json, status: '500'
    end
  end

  def show
    configuration = WmsConfiguration::ConfigurationMaintenance.new
    filter_conditions = {id: params[:id]}
    configuration_hash = (configuration.get_configurations(filter_conditions: filter_conditions).first )
    render json: configuration_hash.to_json
  end
  
  def create
    configuration = WmsConfiguration::ConfigurationMaintenance.new
    message = configuration.add_configuration(params[:app_parameters], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
  rescue Exception => e
    configuration.fatal_error(e.message)
    render json: configuration.message.to_json, status: '500'
  end

  def bulk_create
    configuration = WmsConfiguration::ConfigurationMaintenance.new
    message = configuration.bulk_add_of_configuration(params[:app_parameters], params[:configuration_headers])
    render json: message.to_json, status: message[:status]
  rescue Exception => e
    configuration.fatal_error(e.message)
    render json: configuration.message.to_json, status: '500'
  end

  def update
    configuration = WmsConfiguration::ConfigurationMaintenance.new
    message = configuration.update_configuration(params[:app_parameters], params[:id], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
   rescue Exception => e
    configuration.fatal_error(e.message)
    render json: configuration.message.to_json, status: '500'
  end

  def update_key
    configuration = WmsConfiguration::ConfigurationMaintenance.new
    message = configuration.set_configuration(app_parameter, params[:filter_condition],params[:key], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
  rescue Exception => e
   render json: configuration.message.to_json, status: '500'
  end

  def basic_parameter
    basic_parameter = {client: params[:client], warehouse: params[:warehouse], channel: params[:channel], building: params[:building]}
    basic_parameter[:building] =  basic_parameter[:building].blank? ? nil : basic_parameter[:building]
    basic_parameter[:channel] =  basic_parameter[:channel].blank? ? nil : basic_parameter[:channel]
    basic_parameter
  end

  def app_parameter
    app_parameter = params[:app_parameters]
    app_parameter[:building] =  app_parameter[:building].blank? ? nil : app_parameter[:building]
    app_parameter[:channel] =  app_parameter[:channel].blank? ? nil : app_parameter[:channel]
    app_parameter
  end
end