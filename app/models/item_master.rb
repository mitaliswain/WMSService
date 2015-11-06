class ItemMaster < ActiveRecord::Base
  validates_uniqueness_of :item, scope: :client
  before_create :default_status

  def default_status
    self.status = 'Active'
  end

end
