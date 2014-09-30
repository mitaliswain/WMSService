class LocationController < ApplicationController
  protect_from_forgery except: :index  
  def index
    render json: LocationMaster.all.to_json
  end
  
  def create
    
  end
  
  def update
    p params[:fields_to_update]
    location = LocationMaster.find(params[:id])
    location.attributes(params[:fields_to_update])
    location.save
    
    render json: location.to_json
  end
  
end