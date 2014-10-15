class ConfigurationController < ApplicationController
  protect_from_forgery except: :index  
  def index
    render json: GlobalConfiguration.all.to_json
  end
  
  def create
    
  end
end