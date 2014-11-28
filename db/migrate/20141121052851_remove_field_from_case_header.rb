class RemoveFieldFromCaseHeader < ActiveRecord::Migration
  def change
    remove_column :case_headers, :item, :string
    remove_column :case_headers, :sku_attribute1, :string
    remove_column :case_headers, :sku_attribute2, :string
    remove_column :case_headers, :sku_attribute3, :string
    remove_column :case_headers, :sku_attribute4, :string
    remove_column :case_headers, :sku_attribute5, :string
    remove_column :case_headers, :sku_attribute6, :string
    remove_column :case_headers, :sku_attribute7, :string
    remove_column :case_headers, :sku_attribute8, :string
    remove_column :case_headers, :sku_attribute9, :string
    remove_column :case_headers, :sku_attribute10, :string
    remove_column :case_headers, :barcode, :string
    remove_column :case_headers, :description, :string
    remove_column :case_headers, :short_desc, :string
    remove_column :case_headers, :concept, :string
   # remove_column :case_headers, :from_co, :string
   # remove_column :case_headers, :from_div, :string
   # remove_column :case_headers, :to_co, :string
   # remove_column :case_headers, :to_div, :string

  end

  def down
    add_column :case_headers, :item, :string
    add_column :case_headers, :sku_attribute1, :string
    add_column :case_headers, :sku_attribute2, :string
    add_column :case_headers, :sku_attribute3, :string
    add_column :case_headers, :sku_attribute4, :string
    add_column :case_headers, :sku_attribute5, :string
    add_column :case_headers, :sku_attribute6, :string
    add_column :case_headers, :sku_attribute7, :string
    add_column :case_headers, :sku_attribute8, :string
    add_column :case_headers, :sku_attribute9, :string
    add_column :case_headers, :sku_attribute10, :string
    add_column :case_headers, :barcode, :string
    add_column :case_headers, :description, :string
    add_column :case_headers, :short_desc, :string
    add_column :case_headers, :concept, :string
    add_column :case_headers, :from_co, :string
    add_column :case_headers, :from_div, :string
    add_column :case_headers, :to_co, :string
    add_column :case_headers, :to_div, :string

  end

end
