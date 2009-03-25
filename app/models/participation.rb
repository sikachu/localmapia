# == Schema Information
# Schema version: 20090325065024
#
# Table name: participations
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  event_id   :integer(4)
#  role       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

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
