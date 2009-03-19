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
