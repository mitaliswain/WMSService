class AddLocationToCaseHeader < ActiveRecord::Migration

      def up
            add_column :case_headers, :location, :string
      end

      def down
            remove_column :case_headers, :location, :string
      end

end
