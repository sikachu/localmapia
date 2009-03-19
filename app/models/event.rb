class Event < ActiveRecord::Base
  has_many :feedbacks
  has_many :photos
  has_many :event_photos
  has_many :participations
  has_many :participants, :through => :participations, :source => :user
  belongs_to :location
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :categories, :join_table => :events_categories
  
  STATUS = %w(deleted hidden normal featured)
  before_validation :set_default_status
  before_save :generate_permalink!
  
  validates_presence_of :name
  validates_inclusion_of :status, :in => STATUS
  validates_presence_of :date_start, :date_end
  validates_format_of :url, :with => /^http(s|):\/\//, :allow_blank => true
  validates_presence_of :location
  
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
  
  def generate_permalink!
    self.permalink = self.name.downcase.gsub(/ /, "-")
  end
  
  def set_default_status
    self.status ||= "normal"
  end
  
  def validate
    errors.add(:category, "should not be blank") if self.categories.size.zero?
    errors.add(:date_end, "should come after start date") if self.date_start and self.date_end and self.date_start.to_date > self.date_end.to_date
    errors.add(:time_end, "should come after start date") if self.time_start and self.time_end and self.time_start > self.time_end
  end
end
