module Shipment
  require 'utilities/utility'
  require 'utilities/response'
  
  class ShipmentReceive
    
    include ShipmentReceiveProcessing
    include ShipmentReceiveValidation
    include Response
    include Utility
   
    attr_accessor :message, :error
    FAILED_TO_PROCESS = 'false'
    
    def initialize
      @message = {}
      @error = []
    end
        
  end

end
