require File.dirname(__FILE__) + '/../spec_helper'

describe Report do
  before(:each) do
    @location = mock_model(Location, :id => 1, :title => "Some location")
    @user = mock_model(User, :id => 1, :email => "some@email.com")
    @report = Report.new(:user => @user, :object => @location, :content => "Fail content")
    @report.should be_valid
  end
  
  it "should belongs to a user" do
    @report.user = nil
    @report.should have(1).error_on(:user)
  end
  
  it "should associate with some object" do
    @report.object = nil
    @report.should have(1).error_on(:object)
  end
  
  it "should contains some content" do
    @report.content = ""
    @report.should have(1).error_on(:content)
  end
end
