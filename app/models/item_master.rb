class ItemMaster < ActiveRecord::Base
  validates_uniqueness_of :item, scope: :client
end
