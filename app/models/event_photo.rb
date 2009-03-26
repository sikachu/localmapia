class EventPhoto < ActiveRecord::Base
  belongs_to :event
  
  STATUS = %w(deleted hidden normal)
  before_validation :set_default_status
  
  validates_presence_of :title
  validates_presence_of :event
  validates_inclusion_of :status, :in => STATUS
  
  private
  
  def set_default_status
    self.status ||= "normal"
  end
end
