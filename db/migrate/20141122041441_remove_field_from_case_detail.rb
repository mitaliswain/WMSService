class RemoveFieldFromCaseDetail < ActiveRecord::Migration
  def change
    remove_column :case_details, :pallet_id, :string
    remove_column :case_details, :status, :string
    remove_column :case_details, :inventory_type, :string
    remove_column :case_details, :shipment_nbr, :string
    remove_column :case_details, :shipment_line_nbr, :integer
    remove_column :case_details, :vendor_nbr, :string
    remove_column :case_details, :vendor_factory, :string
    remove_column :case_details, :coo, :string
    remove_column :case_details, :lot_control_nbr, :string
    remove_column :case_details, :serial_nbr, :string
  end

  def down
    add_column :case_details, :pallet_id, :string
    add_column :case_details, :status, :string
    add_column :case_details, :inventory_type, :string
    add_column :case_details, :shipment_nbr, :string
    add_column :case_details, :shipment_line_nbr, :integer
    add_column :case_details, :vendor_nbr, :string
    add_column :case_details, :vendor_factory, :string
    add_column :case_details, :coo, :string
    add_column :case_details, :lot_control_nbr, :string
    add_column :case_details, :serial_nbr, :string
  end
end
