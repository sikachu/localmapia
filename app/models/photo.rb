require 'open-uri'
require 'hpricot'

class Photo < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  belongs_to :event
  
  ALBUM_TYPE = %w(flickr myspace picasa hi5)
  
  validates_presence_of :user
  validates_presence_of :photo_url
  validates_format_of :original_url, :with => /http(s|):\/\//
  before_validation_on_create :set_photo_url
  
  private
  
  def validate
    self.errors.add(:location, "or event should be selected") if self.location_id.nil? and self.event_id.nil?
  end
  
  def validate_on_create
    case album_type
    when "flickr"
      self.errors.add(:original_url, "is invalid") unless self.original_url =~ /flickr.com\/photos\/(.+)\/(.+)\/$/
    else
      self.errors.add(:original_url, "is not supported") unless self.errors.on(:original_url)
    end
  end
  
  def set_photo_url
    case album_type
    when "flickr"
      photo_id = original_url.match(/photos\/(.+)\/(.+)\/$/)[2]
      api_url = "http://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=351c014287d91f20d02c0e9635883f30&photo_id=#{photo_id}"
      logger.info "=> Requesting photo sizes from flickr"
      doc = Hpricot.parse(open(api_url).read)
      self.photo_url = (doc % "size:first")[:source]
    end
  rescue
    self.errors.add(:original_url, "is not supported") unless self.errors.on(:original_url)
  end
end
