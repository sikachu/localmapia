# == Schema Information
# Schema version: 20090325065024
#
# Table name: photos
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)
#  location_id  :integer(4)
#  event_id     :integer(4)
#  album_type   :string(255)
#  photo_url    :string(255)
#  original_url :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Photo < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  belongs_to :event
  
  ALBUM_TYPE = %w(flickr myspace picasa hi5)
  
  validates_presence_of :user
  validates_inclusion_of :album_type, :in => ALBUM_TYPE
  validates_presence_of :photo_url
  validates_format_of :original_url, :with => /http(s|):\/\//
  
  private
  
  def validate
    self.errors.add(:location, "or event should be selected") if self.location.nil? and self.event.nil?
  end
end
