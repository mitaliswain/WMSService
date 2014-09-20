include Utility
include Response

class AsnDetail < ActiveRecord::Base
  attr_accessor :message
  validates_uniqueness_of :sequence, scope: [:client, :shipment_nbr]
  validates_presence_of  :client, :warehouse, :shipment_nbr, :sequence, :item
  validates_presence_of  :building, :channel,  :allow_nil => true
  
  def update_shipment_detail(app_parameters, id, fields_to_update)
       if valid_app_parameters?(app_parameters) && valid_data?(fields_to_update)
         shipment_hash = AsnDetail.find(id)   
         fields_to_update.each do |field, data|
            shipment_hash.attributes =  {field => data} 
         end   
         shipment_hash.save!
        end  
        message 
  end
  
  
  def add_shipment_detail(app_parameters, fields_to_add)
       if valid_data?(fields_to_add)
         shipment_hash = AsnDetail.new 
         app_parameters.each do |field, data|
           shipment_hash.attributes = {field => data}
         end
         fields_to_add.each do |field, data|
            shipment_hash.attributes =  {field => data} 
         end   
         shipment_hash.sequence = shipment_hash.sequence || get_next_sequence(shipment_hash)
         shipment_hash.save!    
         resource_added_successfully("Shipment #{id}", "/shipment/#{shipment_hash.id}")                 
       end        
       message  
  end
  
  def get_next_sequence(shipment_hash)
    shipment_detail = AsnDetail.where(shipment_nbr: shipment_hash.shipment_nbr).last
    shipment_detail.nil? ? 1: shipment_detail.sequence.to_i + 1
  end
  
  def valid_data?(fields_to_update)
    true
  end 
    
end
