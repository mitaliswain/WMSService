class ChangeAsnDetailColumnType < ActiveRecord::Migration
  def change
    change_column :asn_details, :unit_cost, :decimal
    change_column :asn_details, :landing_cost, :decimal
    change_column :asn_details, :retail_price, :decimal
  end
end
