require 'json'

class ConfigurationController < ApplicationController
  protect_from_forgery except: :index  
  def index
    render json: GlobalConfiguration.where(JSON.parse(params.selection)).to_json
  end
  
  def create
    
  end
end