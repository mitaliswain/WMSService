require 'concerns/receive_shipment'
class Shipment
  
  include ReceiveShipment
 
  def initialize
    @error  = []
    @success = []
  end
   
 
 
end