require File.dirname(__FILE__) + '/../spec_helper'

describe Location do
  before(:each) do
    @category = mock_model(Category, :title => "Some category", :navigation => ["Some category"], :category_type => "event")
    @category.should_receive(:valid?).any_number_of_times.and_return(true)
    @category.should_receive(:quoted_id).any_number_of_times.and_return("1")
    @location = mock_model(Location, :id => 1, :title => "Some location")
    @event = mock_model(Event, :id => 1, :name => "Some event")
    @user = mock_model(User, :id => 1, :email => "some@email.com")
    @location = Location.new(:user => @user, :title => "Some title", :description => "Some location which is really cool", :lat => 13.456789, :lng => 10.987654, :city => "Ladkrabang", :province => "Bangkok")
    @location.categories << @category
    @location.should be_valid
  end
  
  it "should belongs to a user" do
    @location.user = nil
    @location.should have(1).error_on(:user)
  end
    
  it "should have title" do
    @location.title = ""
    @location.should have(1).error_on(:title)
  end
  
  it "should have description" do
    @location.description = ""
    @location.should have(1).error_on(:description)
  end
  
  it "should have latitude and longitude" do
    @location.lat = nil
    @location.lng = nil
    @location.should have(1).error_on(:lat)
    @location.should have(1).error_on(:lng)
  end
  
  it "should have city" do
    @location.city = ""
    @location.should have(1).error_on(:city)
  end
  
  it "should have province" do
    @location.province = ""
    @location.should have(1).error_on(:province)
  end
  
  it "should have default country to Thailand" do
    @location.save
    @location.country.should eql("Thailand")
  end
  
  it "should be able to set country" do
    @location.country = "United States"
    @location.save
    Location.first.country.should eql("United States")
  end
  
  it "should have default status to normal" do
    @location.save
    @location.status.should eql("normal")
  end
  
  it "should accepts only valid status" do
    @location.save
    @location.status = "bogus"
    @location.should have(1).error_on(:status)
    Location::STATUS.each do |s|
      @location.status = s
      @location.should be_valid
    end
  end
  
  it "should have default score to zero" do
    @location.save
    @location.score.should eql(0)
  end
  
  it "should have default vote_count to zero" do
    @location.save
    @location.vote_count.should eql(0)
  end
  
  it "should be able to store its parent" do
    @location.parent = Location.create(:user => @user, :title => "Some title", :description => "Some location which is really cool", :lat => 12.456789, :lng => 11.987654, :city => "Ladkrabang", :province => "Bangkok")
    @location.should be_valid
    @location.save
    @location.parent.should_not be_nil
  end
  
  it "should automatically convert tag list to tags (and associate them too)" do
    @location.tag_list = "Dog, book, duck"
    @location.should be_valid
    @location.save
    @location.should have_exactly(3).tags
    @location.tags.collect{ |t| t.name }.should eql(["Dog", "book", "duck"])
  end
  
  it "should have at least one category" do
    @location.categories.clear
    @location.should have(1).error_on(:category)
  end
end
