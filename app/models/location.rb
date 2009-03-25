# == Schema Information
# Schema version: 20090325065024
#
# Table name: locations
#
#  id              :integer(4)      not null, primary key
#  user_id         :integer(4)
#  parent_id       :integer(4)
#  title           :string(255)
#  description     :text
#  lat             :float
#  lng             :float
#  city            :string(255)
#  province        :string(255)
#  country         :string(255)
#  status          :string(255)
#  score           :integer(4)
#  vote_count      :integer(4)
#  additional_info :text
#  created_at      :datetime
#  updated_at      :datetime
#  permalink       :string(255)
#  address         :string(255)
#  version         :integer(4)
#

class Location < ActiveRecord::Base
  has_many :events, :dependent => :destroy
  has_many :feedbacks, :dependent => :destroy
  has_many :photos, :dependent => :destroy
  has_many :regions, :class_name => "LocationRegion", :dependent => :destroy
  has_many :children, :class_name => "Location", :foreign_key => :parent_id
  has_many :votes, :as => :votable
  belongs_to :user
  belongs_to :parent, :class_name => "Location"
  has_and_belongs_to_many :categories, :join_table => "locations_categories"
  has_and_belongs_to_many :tags
  accepts_nested_attributes_for :categories
  acts_as_versioned
  
  STATUS = %w(hidden normal featured)
  before_validation :set_default_status
  before_validation_on_create :fetch_location_information
  before_save :set_default_score_and_vote_count
  after_create :set_permalink
  
  validates_presence_of :user
  validates_presence_of :title
  validates_presence_of :description
  validates_presence_of :lat, :lng, :country
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
  
  # Temporary - We'll use a single category for a while
  def category_id=(category_id)
    return if self.category_ids.include? category_id
    self.category_ids = [category_id]
  end
  
  def category_id
    self.category_ids.first
  end
  
  def category
    self.categories.first
  end
  
  def thumbnail
    @thumbnail ||= "http://maps.google.com/staticmap?center=#{lat},#{lng}&zoom=15&size=100x100&markers=#{lat},#{lng}&key=#{GOOGLE_API_KEY}&sensor=false"
  end
  
  def stars
    unless @stars
      stars = (score * 10 / votes.count)
      puts stars.to_s[-1]
      @stars = case stars.to_s[-1]
        when 49..53; stars.to_i / 10 * 10 + 5
        when 54..57; stars.to_i / 10 * 10 + 10
        when 48; stars.to_i
        else 0
        end
    end
    @stars
  end
  
  def score
    @score ||= votes.sum(:score)
  end
  
  def already_voted?(user)
    votes.exists?(:user_id => user.id)
  end
  
  private
  
  def fetch_location_information
    logger.info "=> Request reverse geocoding data from Google ..."
    response = `curl "http://maps.google.com/maps/geo?q=#{ self.lat },#{ self.lng }&output=csv&oe=utf8&sensor=false&key=#{GOOGLE_API_KEY}&hl=en"`
    if response.present?
      status, accuracy, address = response.split(/,/, 3)
      if status == "200"
        logger.info "** #{address}"
        self.country, self.province, self.city = address[1..-2].split(/, /).reverse
      end
    end
    self.country ||= "Thailand"
    self.province ||= "Bangkok"
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
  
  def set_permalink
    self.permalink = "#{self.id}-#{self.title.downcase.gsub(/ /, "-")}"
    self.save
  end
end
