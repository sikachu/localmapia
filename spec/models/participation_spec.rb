require File.dirname(__FILE__) + '/../spec_helper'

describe Participation do
  before(:each) do
    @event = mock_model(Event, :id => 1, :name => "Some event")
    @user = mock_model(User, :id => 1, :email => "some@email.com")
    @participation = Participation.new(:event => @event, :user => @user)
    @participation.should be_valid
  end

  it "should belongs to a user" do
    @participation.user = nil
    @participation.should have(1).error_on(:user)
  end
  
  it "should belongs to an event" do
    @participation.event = nil
    @participation.should have(1).error_on(:event)
  end
  
  it "should have default role to normal" do
    @participation.save
    @participation.role.should eql("normal")
  end
  
  it "should accepts only valid roles" do
    @participation.role = "bogus"
    @participation.should have(1).error_on(:role)
    Participation::ROLE.each do |r|
      @participation.role = r
      @participation.should be_valid
    end
  end
end
