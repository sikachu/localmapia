require File.dirname(__FILE__) + '/../spec_helper'

describe EventPhoto do
  before(:each) do
    @event = mock_model(Event, :id => 1, :name => "Some event")
    @event_photo = EventPhoto.new(:title => "Some title", :event => @event)
    @event_photo.should be_valid
  end
  
  it "should have title" do
    @event_photo.should be_valid
    @event_photo.title = ""
    @event_photo.should have_exactly(1).error_on(:title)
  end
    
  it "should belongs to event" do
    @event_photo.event = nil
    @event_photo.should have_exactly(1).error_on(:event)
  end
  
  it "should automatically resize photo, and put them in appropriate folders"
  
  it "should have default status to normal" do
    @event_photo.save
    @event_photo.status.should eql("normal")
  end
  
  it "should accepts only valid status" do
    @event_photo.save
    @event_photo.status = "bogus"
    @event_photo.should have(1).error_on(:status)
    EventPhoto::STATUS.each do |s|
      @event_photo.status = s
      @event_photo.should be_valid
    end
  end
end
