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
  
  private
  
  def validate
    self.errors.add(:title, "should be unique") if Category.count(:conditions => {:title => self.title, :category_type => self.category_type}) > 0
  end
  
  def calculate_navigation
    self.navigation = [self.title]
    object = self
    if object.parent
      self.navigation.unshift object.parent.title
    end
  end
end
