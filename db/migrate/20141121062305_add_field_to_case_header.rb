class AddFieldToCaseHeader < ActiveRecord::Migration
  def up
    add_column :case_headers, :from_channel, :string
    add_column :case_headers, :from_building, :string
    add_column :case_headers, :to_channel, :string
    add_column :case_headers, :to_building, :string
  end

  def down
    remove_column :case_headers, :from_channel, :string
    remove_column :case_headers, :from_building, :string
    remove_column :case_headers, :to_channel, :string
    remove_column :case_headers, :to_building, :string
  end
end
