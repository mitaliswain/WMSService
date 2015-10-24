class ItemInnerPack < ActiveRecord::Base
  before_validation :convert_blank_to_null_for_building_and_channel
end
