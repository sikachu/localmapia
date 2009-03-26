class EventLog < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :user
  validates_presence_of :action
  
  def self.top_contributors
    all(:conditions => {:action => %w(new_location update_location new_event update_event)}, :group => "user_id, content", :select => "COUNT(DISTINCT action, content) AS count_all, event_logs.*")
  end
end
