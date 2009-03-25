# == Schema Information
# Schema version: 20090325065024
#
# Table name: messages
#
#  id         :integer(4)      not null, primary key
#  from_id    :integer(4)
#  to_id      :integer(4)
#  title      :string(255)
#  content    :text
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Message < ActiveRecord::Base
  belongs_to :from, :class_name => "User", :foreign_key => "from_id"
  belongs_to :to, :class_name => "User", :foreign_key => "to_id"
  
  STATUS = %w(deleted unread read)
  before_validation :set_default_status
  
  validates_presence_of :title
  validates_presence_of :content
  validates_presence_of :from, :to
  validates_inclusion_of :status, :in => STATUS
  
  private
  
  def set_default_status
    self.status ||= "unread"
  end
end
