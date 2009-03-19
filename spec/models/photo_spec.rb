require File.dirname(__FILE__) + '/../spec_helper'

describe Photo do
  before(:each) do
    @location = mock_model(Location, :id => 1, :title => "Some location")
    @event = mock_model(Event, :id => 1, :name => "Some event")
    @user = mock_model(User, :id => 1, :email => "some@email.com")
    @photo = Photo.new(:user => @user, :event => @event, :location => @location, :album_type => "flickr", :photo_url => "http://some_url", :original_url => "http://original_url")
    @photo.should be_valid
  end
  
  it "should belongs to a user" do
    @photo.user = nil
    @photo.should have(1).error_on(:user)
  end
  
  it "should belongs to either location or event" do
    @photo.location = nil
    @photo.should be_valid
    @photo.event = nil
    @photo.should have_exactly(1).error_on(:location)
    @photo.location = @location
    @photo.should be_valid
  end
  
  it "should contains only valid album_type" do
    @photo.album_type = "bogus"
    @photo.should have(1).error_on(:album_type)
    Photo::ALBUM_TYPE.each do |t|
      @photo.album_type = t
      @photo.should be_valid
    end
  end
  
  it "should contains photo_url" do
    @photo.save
    @photo.photo_url = ""
    @photo.should have(1).error_on(:photo_url)
  end
  
  it "should contains original_url" do
    @photo.original_url = ""
    @photo.should have(1).error_on(:original_url)
  end
  
  it "should be able to fetch photo_url for flickr"
  
  it "should have valid original_url (begins with http(s)://)" do
    @photo.original_url = "not_valid_url"
    @photo.should have_exactly(1).error_on(:original_url)
    @photo.original_url = "http://valid.url"
    @photo.should be_valid
    @photo.original_url = "https://valid.url"
    @photo.should be_valid
  end
end
