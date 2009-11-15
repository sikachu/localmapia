class EventLog < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :user
  validates_presence_of :action
  
  def self.top_contributors
    all(:conditions => {:action => %w(create_location update_location create_event update_event)}, :group => "user_id", :select => "COUNT(*) AS count_all, event_logs.*", :order => "count_all DESC", :limit => 5)
  end
end
