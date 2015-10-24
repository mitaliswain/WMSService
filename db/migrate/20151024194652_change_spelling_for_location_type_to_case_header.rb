class ChangeSpellingForLocationTypeToCaseHeader < ActiveRecord::Migration
def up
      remove_column :case_headers, :Location_type
      add_column :case_headers, :location_type, :string

    end

    def down
      add_column :case_headers, :Location_type, :string
      remove_column :case_headers, :location_type, :string
      
    end
end
