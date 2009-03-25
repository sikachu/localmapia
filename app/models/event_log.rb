# == Schema Information
# Schema version: 20090325065024
#
# Table name: event_logs
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  action     :string(255)
#  content    :text
#  ip_address :string(255)
#  user_agent :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class EventLog < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :user
  validates_presence_of :action
end
