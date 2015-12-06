module Shipment
  require 'utilities/utility'
  require 'utilities/response'
  
  class ShipmentReceive
    
    include ShipmentReceiveProcessing
    include ShipmentReceivePalletProcessing
    include ShipmentReceiveValidation
    include Response
    include Utility
   
    attr_accessor :message, :error, :shipment
    FAILED_TO_PROCESS = 'false'
    
    def initialize(shipment)
      @message = {}
      @error = []
      @shipment = shipment
    end
        
  end

end
