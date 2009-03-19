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
  accepts_nested_attributes_for :regions
  
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
