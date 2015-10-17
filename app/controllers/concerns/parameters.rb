module Parameters
  
  def basic_parameters
    basic_parameter = {client: params[:client], warehouse: params[:warehouse], channel: params[:channel], building: params[:building]}
    basic_parameter[:building] =  basic_parameter[:building].blank? ? nil : basic_parameter[:building]
    basic_parameter[:channel] =  basic_parameter[:channel].blank? ? nil : basic_parameter[:channel]
    basic_parameter
  end
  
end  