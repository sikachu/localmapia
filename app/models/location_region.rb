# == Schema Information
# Schema version: 20090325065024
#
# Table name: location_regions
#
#  id          :integer(4)      not null, primary key
#  location_id :integer(4)
#  lat         :float
#  lng         :float
#  created_at  :datetime
#  updated_at  :datetime
#

class LocationRegion < ActiveRecord::Base
  belongs_to :location
end
