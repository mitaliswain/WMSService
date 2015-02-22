class RemoveLocationDetailsFromCaseHeader < ActiveRecord::Migration

  def change
    remove_column :case_headers, :area, :string
    remove_column :case_headers, :zone, :string
    remove_column :case_headers, :aisle, :string
    remove_column :case_headers, :bay, :string
    remove_column :case_headers, :level, :string
    remove_column :case_headers, :position, :string
    remove_column :case_headers, :previous_area, :string
    remove_column :case_headers, :previous_zone, :string
    remove_column :case_headers, :previous_aisle, :string
    remove_column :case_headers, :previous_bay, :string
    remove_column :case_headers, :previous_level, :string
    remove_column :case_headers, :previous_position, :string
  end

  def down
    add_column :case_headers, :area, :string
    add_column :case_headers, :zone, :string
    add_column :case_headers, :aisle, :string
    add_column :case_headers, :bay, :string
    add_column :case_headers, :level, :string
    add_column :case_headers, :position, :string
    add_column :case_headers, :previous_area, :string
    add_column :case_headers, :previous_zone, :string
    add_column :case_headers, :previous_aisle, :string
    add_column :case_headers, :previous_bay, :string
    add_column :case_headers, :previous_level, :string
    add_column :case_headers, :previous_position, :string
  end


end
