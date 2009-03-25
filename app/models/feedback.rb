# == Schema Information
# Schema version: 20090325065024
#
# Table name: feedbacks
#
#  id          :integer(4)      not null, primary key
#  location_id :integer(4)
#  event_id    :integer(4)
#  user_id     :integer(4)
#  content     :text
#  rank        :integer(4)
#  status      :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Feedback < ActiveRecord::Base
  belongs_to :location
  belongs_to :event
  belongs_to :user
  
  STATUS = %w(deleted normal)
  before_create :set_default_rank
  before_validation :set_default_status
  
  validates_presence_of :user
  validates_presence_of :content
  validates_inclusion_of :status, :in => STATUS
  
  private
  
  def set_default_rank
    self.rank = 0
  end
  
  def set_default_status
    self.status ||= "normal"
  end
  
  def validate
    self.errors.add(:location, "or event should be selected") if self.location.nil? and self.event.nil?
  end
end
