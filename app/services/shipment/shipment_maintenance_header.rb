module Shipment
  require 'utilities/utility'
  require 'utilities/response'
  
  include Utility
  include Response
  
  module ShipmentMaintenanceHeader
       
    class HeaderMaintenance
      attr_accessor :message, :error

      def initialize
        @message = {}
        @error = []
      end

      def add_shipment_header(app_parameters, fields_to_add)
             input_obj = app_parameters.merge(fields_to_add).to_hash
             if valid_data?(input_obj) && valid_app_parameters?(input_obj)
                shipment_hash = AsnHeader.new(input_obj)
                shipment_hash = add_derived_data(shipment_hash.clone)
               shipment_hash.save!
               resource_added_successfully("Shipment #{shipment_hash.id}", "/shipment/#{shipment_hash.id}")
             end
             message
        end

        def update_shipment_header(app_parameters, id, fields_to_update)
             input_obj = app_parameters.merge(fields_to_update).merge(id: id).to_hash
             if valid_app_parameters?(input_obj) && valid_data?(input_obj)
               shipment_hash = AsnHeader.find(id)
               fields_to_update.each do |field, data|
                  shipment_hash.attributes =  {field => data}
               end
               shipment_hash.save!
               resource_updated_successfully("Shipment #{id}")
              end
              message
        end

 private
        def add_derived_data(asn_header)
          basic_parameters = {client: asn_header.client, warehouse: asn_header.warehouse, channel: nil, building: nil}
          asn_header.shipment_nbr= get_next_one_up_number(basic_parameters, 'SHIPMENT') if (asn_header.shipment_nbr.nil? or asn_header.shipment_nbr.blank?)
          asn_header
        end

        def valid_data?(fields_to_update)
          is_valid = true
          fields_to_update.each do |field, value|
              method ="valid_#{field.to_s}?"
              if (method == "valid_asn_type?")
                p method
                p respond_to?(method)
              end
              is_valid = (respond_to?(method) ? send(method, fields_to_update) : true)  && is_valid
          end
          is_valid
        end

        def valid_asn_type?(fields_to_update)
          p fields_to_update
          valid_asn_type=['PO', 'Inbound', 'Warehouse Transfer']
          if valid_asn_type.include? fields_to_update.asn_type
             true
          else
             validation_failed('422', :asn_type, 'Invalid ASN Type')
          end
        end

        def valid_hot_item_po?(fields_to_update)

           if fields_to_update.hot_item_po != "Y" &&  fields_to_update.hot_item_po != "N"
             validation_failed('422', :hot_item_po, 'Invalid Hot Item  PO')
           else
             true
          end
        end

        def valid_purchase_order_nbr?(fields_to_update)
          if !fields_to_update.purchase_order_nbr.present?
            validation_failed('422', :purchase_order_nbr, 'Invalid purchase order')
          else
             true
          end
        end

        def valid_vendor_nbr?(fields_to_update)
          if !fields_to_update.vendor_nbr.present?
            validation_failed('422', :vendor_nbr, 'Invalid vendor number')
          else
             true
          end

        end

        def valid_track_lot_control?(fields_to_update)

           if fields_to_update.track_lotcontrol != "Y" &&  fields_to_update.track_lotcontrol != "N"
             validation_failed('422', :track_lotcontrol, 'Invalid lot control')
           else
             true
           end
        end
      end
    end
end  