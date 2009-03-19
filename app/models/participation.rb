class Participation < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  
  ROLE = %w(normal organizer)
  before_validation :set_default_role
  
  validates_presence_of :user
  validates_presence_of :event
  validates_inclusion_of :role, :in => ROLE
  
  private
  
  def set_default_role
    self.role ||= "normal"
  end
end
