require 'utilities/utility'
require 'utilities/response'

include Utility
include Response
class CaseHeader < ActiveRecord::Base
  validates_uniqueness_of :case_id, scope: :client
  before_validation :convert_blank_to_null_for_building_and_channel   
end
