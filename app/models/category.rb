class Category < ActiveRecord::Base
  has_many :category_fields
  belongs_to :parent, :class_name => "Category"
  has_many :children, :class_name => "Category", :foreign_key => 'parent_id'
  has_and_belongs_to_many :locations, :join_table => "locations_categories"
  has_and_belongs_to_many :events, :join_table => "events_categories"
  
  CATEGORY_TYPE = %w(location event)
  serialize :navigation
  
  validates_presence_of :title
  validates_inclusion_of :category_type, :in => CATEGORY_TYPE
  before_save :calculate_navigation, :set_permalink
  
  named_scope :for_location, :conditions => { :category_type => "location" }
  named_scope :for_event, :conditions => { :category_type => "event" }
  named_scope :first_level, :conditions => { :parent_id => nil }
  named_scope :second_level, lambda { |parent_id| { :conditions => { :parent_id => parent_id }}}
  
  private
  
  def children_locations(opts={})
    Location.all({:select => "locations.*", :from => "locations_categories", :joins => "JOIN locations ON locations_categories.location_id = locations.id", :conditions => "locations_categories.category_id IN (SELECT id FROM categories WHERE parent_id = #{id})"}.merge(opts))
  end
  
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
  
  def set_permalink
    self.permalink = title.downcase.gsub(/(\/| )+/, '-')
  end
end
