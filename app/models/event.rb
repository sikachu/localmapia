class Event < ActiveRecord::Base
  has_many :feedbacks
  has_many :photos
  has_many :event_photos
  has_many :participations
  has_many :participants, :through => :participations, :source => :user
  has_many :votes, :as => :votable
  belongs_to :location
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :categories, :join_table => :events_categories
  has_and_belongs_to_many :watchers, :class_name => "User"
  
  STATUS = %w(deleted hidden normal featured)
  before_validation :set_default_status
  after_create :set_permalink
  acts_as_versioned
  
  validates_presence_of :name
  validates_inclusion_of :status, :in => STATUS
  validates_presence_of :date_start, :date_end
  validates_format_of :url, :with => /^http(s|):\/\//, :allow_blank => true
  validates_presence_of :location
  
  named_scope :active, :conditions => ["date_end > ?", Date.today], :order => "date_start DESC"
  
  def tag_list=(str)
    self.tags.clear
    str.split(/,/).each do |tag_name|
      self.tags << Tag.find_or_create_by_name(tag_name.strip)
    end
  end
  
  def tag_list
    @tag_list ||= tags.collect{ |t| t.name }.join(", ")
  end
  
  def time_start
    self[:time_start] ||= Time.parse("9:00")
  end
  
  def time_end
    self[:time_end] ||= Time.parse("18:00")
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
  
  def duration
    date = if date_start.year == date_end.year
        if date_start.month == date_end.month
          "#{date_start.strftime("%B %d")} - #{date_end.strftime("%d, %Y")}."
        else
          "#{date_start.strftime("%B %d")} - #{date_end.strftime("%B %d, %Y")}."
        end
      else
        "#{date_start.strftime("%B %d, %Y")} - #{date_end.strftime("%B %d, %Y")}."
      end
    time = formatted_time(time_start) + " until " + formatted_time(time_end)
    
    "#{date} #{time}"
  end
  
  private
  
  def set_permalink
    self.permalink = "#{self.id}-#{self.name.downcase.gsub(/ /, "-")}@#{location.title.gsub(/ /, "-")}"
    self.save
  end
  
  def formatted_time(time)
    if time.hour.zero? and time.minute.zero?
      "Midnight"
    elsif time.hour == "12" and time.minute.zero?
      "Noon"
    else
      time.strftime("%I:%M %p")
    end
  end
  
  def set_default_status
    self.status ||= "normal"
  end
  
  def validate_on_create
    errors.add(:category, "should not be blank") if self.categories.size.zero?
    errors.add(:date_end, "should come after start date") if self.date_start and self.date_end and self.date_start.to_date > self.date_end.to_date
    errors.add(:time_end, "should come after start time") if self.time_start and self.time_end and self.time_start > self.time_end
  end
end
