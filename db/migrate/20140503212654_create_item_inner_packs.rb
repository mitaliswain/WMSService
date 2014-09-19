class CreateItemInnerPacks < ActiveRecord::Migration
  def change
    create_table :item_inner_packs do |t|
      t.string :client
      t.string :warehouse
      t.string :channel
      t.string :building
      t.string :item
      t.string :sku_attribute1
      t.string :sku_attribute2
      t.string :sku_attribute3
      t.string :sku_attribute4
      t.string :sku_attribute5
      t.string :sku_attribute6
      t.string :sku_attribute7
      t.string :sku_attribute8
      t.string :sku_attribute9
      t.string :sku_attribute10
      t.string :sku_attribute11
      t.string :sku_attribute12
      t.string :sku_attribute13
      t.string :sku_attribute14
      t.string :sku_attribute15
      t.string :sku_attribute16
      t.string :sku_attribute17
      t.string :sku_attribute18
      t.string :sku_attribute19
      t.string :sku_attribute20
      t.string :sku_attribute21
      t.string :sku_attribute22
      t.string :sku_attribute23
      t.string :sku_attribute24
      t.string :sku_attribute25
      t.string :concept
      t.string :description
      t.string :short_desc
      t.string :barcode
      t.string :innerpack_code
      t.integer :innerpack_qty
      t.decimal :innerpack_wgt
      t.decimal :innerpack_vol
      t.decimal :innerpack_len
      t.decimal :innerpack_wdt
      t.decimal :innerpack_hgt
      t.string :hold_inventory
      t.string :hold_type
      t.string :status
      t.datetime :created_date
      t.string :created_user
      t.string :created_prc
      t.datetime :update_date
      t.string :updated_user
      t.string :updated_prc

      t.timestamps
    end
  end
  
  def down
    drop_table :item_inner_packs
  end
end
