class AddShippedQuantityToAsnDetails < ActiveRecord::Migration
  def change
    add_column :asn_details, :shipped_quantity, :integer
  end
  
  def down
    remove_column :asn_details, :shipped_quantity, :integer
  end
end
