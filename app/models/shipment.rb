require 'concerns/receive_shipment.rb'
class Shipment
  
  include ReceiveShipment
 
  def initialize
    @error  = []
    @success = []
  end
   
 
 
end