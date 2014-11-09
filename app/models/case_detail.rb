require 'utilities/utility'
require 'utilities/response'

include Utility
include Response

class CaseDetail < ActiveRecord::Base
  validates_uniqueness_of :item, scope: [:client, :case_id]
  validates_presence_of  :client, :warehouse, :case_id, :item, :case_header_id
  validates_presence_of  :building, :channel,  :allow_nil => true
  before_validation :convert_blank_to_null_for_building_and_channel  
end
