require File.dirname(__FILE__) + '/../spec_helper'

describe Message do
  before(:each) do
    @user_1 = mock_model(User, :id => 1, :email => "some@email.com")
    @user_2 = mock_model(User, :id => 2, :email => "another@email.com")
    @message = Message.new(:from => @user_1, :to => @user_2, :title => "Hello world", :content => "Euraka!")
    @message.should be_valid
  end
  
  it "should have title" do
    @message.title = ""
    @message.should have(1).error_on(:title)
  end
  
  it "should have content" do
    @message.content = ""
    @message.should have(1).error_on(:content)
  end
  
  it "should have default status to unread" do
    @message.save
    @message.status.should eql("unread")
  end
  
  it "should accepts only valid status" do
    @message.save
    @message.status = "bogus"
    @message.should have(1).error_on(:status)
    Message::STATUS.each do |s|
      @message.status = s
      @message.should be_valid
    end
  end
    
  it "should have from and to user" do
    @message.from = nil
    @message.should have(1).error_on(:from)
    @message.from = @user_1
    @message.to = nil
    @message.should have(1).error_on(:to)
  end
end
