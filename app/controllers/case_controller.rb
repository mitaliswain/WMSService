class CaseController < ApplicationController
  
  protect_from_forgery except: :index
  def index
     filter_conditions = params[:filter_conditions]
     case_hash = Inventory::CaseMaintenance.new.get_cases(basic_parameters, filter_conditions, params[:expand])
     render json: case_hash.to_json, status: '200'
  end
  
  def show
    case_obj = Inventory::CaseMaintenance.new
    filter_conditions = {id: params[:id]}
    case_hash = (case_obj.get_cases(basic_parameters, filter_conditions, true)).first
    render json: case_hash.to_json
  end
  
  def basic_parameters
    #{client: params[:app_parameters][:client], warehouse: params[:app_parameters][:warehouse], channel: params[:app_parameters][:channel], building: params[:app_parameters][:building]}
    {client:'WM', warehouse: 'WH1', building: '', channel: ''}
       
  end
  def update_header
    case_obj = Inventory::CaseMaintenance.new
    message = case_obj.update_case_header(params[:app_parameters], params[:id], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
   rescue Exception => e
     case_obj.fatal_error(e.message)
    render json: case_obj.message.to_json, status: '500'
  end
  
   def add_header
    case_obj = Inventory::CaseMaintenance.new
    message = case_obj.add_case_header(params[:app_parameters], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
   rescue Exception => e
    case_obj.fatal_error(e.message)
    render json: case_obj.message.to_json, status: '500'
   end

  def add_detail
    case_obj = Inventory::CaseMaintenance.new
    message = case_obj.add_case_detail(params[:app_parameters], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
  rescue Exception => e
    case_obj.fatal_error(e.message)
    render json: case_obj.message.to_json, status: '500'
  end

  def update_detail
    case_obj = Inventory::CaseMaintenance.new
    message = case_obj.update_case_detail(params[:app_parameters], params[:id], params[:fields_to_update])
    render json: message.to_json, status: message[:status]
  rescue Exception => e
    case_obj.fatal_error(e.message)
    render json: case_obj.message.to_json, status: '500'
  end


end