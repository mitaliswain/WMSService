class UserMaster < ActiveRecord::Base
  
    validates_uniqueness_of :user_id, scope: :client
    
end
