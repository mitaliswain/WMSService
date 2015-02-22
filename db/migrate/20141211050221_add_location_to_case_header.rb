class AddLocationToCaseHeader < ActiveRecord::Migration

    def up
      add_column :case_headers, :location, :string
      add_column :case_headers, :previous_location, :string
    end

    def down
      remove_column :case_headers, :location, :string
      remove_column :case_headers, :previous_location, :string
    end

end
