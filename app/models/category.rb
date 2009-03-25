class Category < ActiveRecord::Base
  has_many :category_fields
  belongs_to :parent, :class_name => "Category"
  has_and_belongs_to_many :locations
  has_and_belongs_to_many :events
  
  CATEGORY_TYPE = %w(location event)
  serialize :navigation
  
  validates_presence_of :title
  validates_inclusion_of :category_type, :in => CATEGORY_TYPE
  before_save :calculate_navigation
  
  named_scope :for_location, :conditions => { :category_type => "location" }
  named_scope :for_event, :conditions => { :category_type => "event" }
  named_scope :first_level, :conditions => { :parent_id => nil }
  named_scope :second_level, lambda { |parent_id| { :conditions => { :parent_id => parent_id }}}
  
  private
  
  def validate
    if self.new_record? # Validate on create only
      self.errors.add(:title, "should be unique (#{{:title => self.title, :category_type => self.category_type, :parent_id => self.parent_id}.inspect})") if Category.count(:conditions => {:title => self.title, :category_type => self.category_type, :parent_id => self.parent_id}) > 0
    end
  end
  
  def calculate_navigation
    self.navigation = [self.title]
    object = self
    if object.parent
      self.navigation.unshift object.parent.title
    end
  end
end
