require 'utilities/utility'
require 'utilities/response'

include Utility
include Response

class CaseDetail < ActiveRecord::Base
  validates_uniqueness_of :case_id, scope: [:client, :item]
  before_validation :convert_blank_to_null_for_building_and_channel  
end
