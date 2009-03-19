require File.dirname(__FILE__) + '/../spec_helper'

describe Feedback do
  before(:each) do
    @location = mock_model(Location, :id => 1, :title => "Some location")
    @event = mock_model(Event, :id => 1, :name => "Some event")
    @user = mock_model(User, :id => 1, :email => "some@email.com")
    @feedback = Feedback.new(:location => @location, :event => @event, :user => @user, :content => "Hello world")
    @feedback.should be_valid
  end
  
  it "should belongs to either location or event" do
    @feedback.location = nil
    @feedback.should be_valid
    @feedback.event = nil
    @feedback.should have_exactly(1).error_on(:location)
    @feedback.location = @location
    @feedback.should be_valid
  end
  
  it "should belongs to a user" do
    @feedback.user = nil
    @feedback.should have_exactly(1).error_on(:user)
  end
  
  it "should have content" do
    @feedback.content = ""
    @feedback.should have_exactly(1).error_on(:content)
  end
  
  it "should have rank defaults to 0" do
    @feedback.save
    @feedback.rank.should eql(0)
  end
  
  it "should have default status to normal" do
    @feedback.save
    @feedback.status.should eql("normal")
  end
  
  it "should accepts only valid status" do
    @feedback.save
    @feedback.status = "bogus"
    @feedback.should have(1).error_on(:status)
    Feedback::STATUS.each do |s|
      @feedback.status = s
      @feedback.should be_valid
    end
  end
end
