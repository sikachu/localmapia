require File.dirname(__FILE__) + '/../spec_helper'

describe Event do
  before(:each) do
    @time = Time.now
    @category = mock_model(Category, :title => "Some category", :navigation => ["Some category"], :category_type => "event")
    @category.should_receive(:valid?).any_number_of_times.and_return(true)
    @category.should_receive(:quoted_id).any_number_of_times.and_return("1")
    @location = mock_model(Location, :id => 1, :title => "Some location")
    @event = Event.new(:name => "Some name asd$30er04", :date_start => @time.to_date, :date_end => @time.tomorrow.to_date, :location => @location)
    @event.categories << @category
    @event.should be_valid
  end
  
  it "should have name" do
    @event.name = ""
    @event.should have_exactly(1).error_on(:name)
  end
  
  it "should automatically generate unique permalink" do
    @another_event = Event.new(:name => "Some name asd$30er04", :date_start => @time.to_date, :date_end => @time.tomorrow.to_date, :location => @location)
    @another_event.categories << @category
    @event.save!
    @another_event.save!
    @event.permalink.should_not be_nil
    @another_event.permalink.should_not be_nil
  end
  
  it "should have date_start and date_end" do
    @event.date_start = nil
    @event.date_end = nil
    @event.should have_exactly(1).error_on(:date_start)
    @event.should have_exactly(1).error_on(:date_end)
  end
  
  it "should check whether date_start is before date_end or not" do
    @event.date_end = Time.now - 1.day
    @event.should have_exactly(1).error_on(:date_end)
  end
  
  it "should check whether time_start is before time_end or not" do
    @event.time_start = "05:00:00"
    @event.time_end = "03:00:00"
    @event.should have_exactly(1).error_on(:time_end)
    @event.time_end = "07:00:00"
    @event.should be_valid
  end
  
  it "should have default status to normal" do
    @event.save
    @event.status.should eql("normal")
  end
  
  it "should accepts only valid status" do
    @event.save
    @event.status = "bogus"
    @event.should have(1).error_on(:status)
    Event::STATUS.each do |s|
      @event.status = s
      @event.should be_valid
    end
  end
  
  it "should automatically convert tag list to tags (and associate them too)" do
    @event.tag_list = "Dog, book, duck"
    @event.should be_valid
    @event.save
    @event.should have_exactly(3).tags
    @event.tags.collect{ |t| t.name }.should eql(["Dog", "book", "duck"])
  end
  
  it "should accepts only url begins with http(s)://" do
    @event.url = "not_valid_url"
    @event.should have_exactly(1).error_on(:url)
    @event.url = "http://valid.url"
    @event.should be_valid
    @event.url = "https://valid.url"
    @event.should be_valid
  end
  
  it "should belongs to a location" do
    @event.location = nil
    @event.should have_exactly(1).error_on(:location)
  end
  
  it "should have at least one category" do
    @event.categories.clear
    @event.should have(1).error_on(:category)
  end
end
