# == Schema Information
# Schema version: 20090325065024
#
# Table name: event_photos
#
#  id         :integer(4)      not null, primary key
#  event_id   :integer(4)
#  title      :string(255)
#  photo      :string(255)
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

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
