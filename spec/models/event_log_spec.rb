require File.dirname(__FILE__) + '/../spec_helper'

describe EventLog do
  before(:each) do
    @user = mock_model(User, :id => 1, :email => "some@email.com")
    @event_log = EventLog.new(:user => @user, :action => "login")
    @event_log.should be_valid
  end
  
  it "should contains user_id" do
    @event_log.should be_valid
    @event_log.user = nil
    @event_log.should have_exactly(1).error_on(:user)
  end
  
  it "should contains action" do
    @event_log.action = ""
    @event_log.should have_exactly(1).error_on(:action)
  end
end
