class LocationType < ActiveRecord::Base
  validates_uniqueness_of :location_type, scope: [:client, :warehouse]
end
