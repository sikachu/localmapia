class Location < ActiveRecord::Base
  has_many :events, :dependent => :destroy
  has_many :feedbacks, :dependent => :destroy
  has_many :photos, :dependent => :destroy
  has_many :regions, :class_name => "LocationRegion", :dependent => :destroy
  has_many :children, :class_name => "Location", :foreign_key => :parent_id
  belongs_to :user
  belongs_to :parent, :class_name => "Location"
  has_and_belongs_to_many :categories, :join_table => "locations_categories"
  has_and_belongs_to_many :tags
  accepts_nested_attributes_for :categories
  
  STATUS = %w(hidden normal featured)
  before_validation :set_default_country, :set_default_status
  before_save :set_default_score_and_vote_count
  
  validates_presence_of :user
  validates_presence_of :title
  validates_presence_of :description
  validates_presence_of :lat, :lng, :city, :province, :country
  validates_inclusion_of :status, :in => STATUS
  
  def tag_list=(str)
    self.tags.clear
    str.split(/,/).each do |tag_name|
      self.tags << Tag.find_or_create_by_name(tag_name.strip)
    end
  end
  
  def tag_list
    @tag_list ||= tags.collect{ |t| t.name }.join(", ")
  end
  
  def latlng=(latlngs)
    lat, lng = latlngs.first.split(/\|/)
    min_lat = max_lat = lat.to_f
    min_lng = max_lng = lng.to_f
    
    latlngs.each do |latlng|
      lat, lng = latlng.split(/\|/)
      self.regions.build(:lat => lat.to_f, :lng => lng.to_f)
      
      # cache it
      min_lat = lat.to_f if lat.to_f < min_lat
      min_lng = lng.to_f if lng.to_f < min_lng
      max_lat = lat.to_f if lat.to_f > max_lat
      max_lng = lng.to_f if lng.to_f > max_lng
    end
    self.lat = (min_lat + max_lat) / 2.0
    self.lng = (min_lng + max_lng) / 2.0
  end
  
  def regions_for_google
    @regions_for_google = self.regions.collect{ |r| "new GLatLng(#{r.lat}, #{r.lng})" }.join(",") + ",new GLatLng(#{self.regions.first.lat}, #{self.regions.first.lng})"
  end
  
  private
  
  def set_default_country
    self.country ||= "Thailand"
  end
  
  def set_default_status
    self.status ||= "normal"
  end
  
  def set_default_score_and_vote_count
    self.score = self.vote_count = 0
  end
  
  def validate
    errors.add(:category, "should not be blank") if self.categories.size.zero?
  end
end
