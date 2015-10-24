class AddTrackingToUserMaster < ActiveRecord::Migration

 def up
      add_column :user_masters, :status, :string
      add_column :user_masters, :last_login, :datetime
      add_column :user_masters, :created_date, :datetime
      add_column :user_masters, :created_user, :string
      add_column :user_masters, :created_prc, :string
      add_column :user_masters, :update_date, :datetime
      add_column :user_masters, :updated_user, :string
      add_column :user_masters, :updated_prc, :string

    end

    def down
      remove_column :user_masters, :status, :string
      remove_column :user_masters, :last_login, :datetime
      remove_column :user_masters, :created_date, :datetime
      remove_column :user_masters, :created_user, :string
      remove_column :user_masters, :created_prc, :string
      remove_column :user_masters, :update_date, :datetime
      remove_column :user_masters, :updated_user, :string
      remove_column :user_masters, :updated_prc, :string
      
    end
    
end
