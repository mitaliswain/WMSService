class LocationMaster < ActiveRecord::Base
  validates_uniqueness_of :position, scope: [:client, :warehouse, :channel, :building, :area, :zone, :aisle, :bay, :level]
end
